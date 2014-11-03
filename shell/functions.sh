# ~/.shell/functions.sh

################################################################################
# a simple logger
# Constants: LOGFILE
################################################################################
function log() {
    local -r LOGFILE="${HOME}/.shell/shell.log"
    echo "[$(date '+%F %T %Z') ${FUNCNAME[1]}] $@" >> "$LOGFILE"
}

############################################################
# used to get user answer interactivly
# Options:
############################################################
function confirm() {
    local -a args="${@}"
    local opt
    local OPTIND=1
    while getopts "d:hp:t:T:" opt; do
        case "$opt" in
            d)
                if [ "$OPTARG" -eq "$OPTARG" 2> /dev/null ]; then
                    local -r -i default="$OPTARG"
                else
                    echo "Invalid number '${OPTARG}' for option 'd'" >&2
                    return 1
                fi
                ;;
            h)
                cat <<End-Of-Help
Usage: confirm [option]
    options:
        -d valued returned when Enter pressed, default 0
        -h print help message and exit
        -p prompt
        -t timeout, default is 3
        -T value returned when timeout, defalut is read errcode
End-Of-Help
                return
                ;;
            p)
                if [ -n "$OPTARG" ]; then
                    prompt="${OPTARG}, are you sure ?"
                else
                    echo "Invalid prompt '${OPTARG}' for option 'p'" >&2
                    return 1
                fi
                ;;
            t)
                if [ "$OPTARG" -eq "$OPTARG" 2> /dev/null ]; then
                    local -r -i timeout="$OPTARG"
                else
                    echo "Invalid number '${OPTARG}' for option 't'" >&2
                    return 1
                fi
                ;;
            T)
                if [ "$OPTARG" -eq "$OPTARG" 2> /dev/null ]; then
                    local -r -i tmodef="$OPTARG"
                else
                    echo "Invalid number '${OPTARG}' for option 'T'" >&2
                    return 1
                fi
                ;;
            ?)
                confirm -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    local reply
    read -n 1 -p "${prompt:-Are you sure ?} [y/n]: " -t "${timeout:-3}" -r reply
    local -i retval=$?
    # timeout or Ctrl-C
    if [ $retval -ne 0 ]; then
        if [ $retval -gt 128 ]; then
            echo "timeout"
            return ${tmodef:-$retval}
        else
            echo "failed"
            return $retval
        fi
    fi
    local emsg=''
    case "${reply:-enter}" in
        enter)
            emsg='default'
            retval=${default:-0}
            ;;
        y|Y) retval=0 ;;
        $'\x04'|n|N) retval=1 ;;
        *)
            echo "Invalid input: '${reply}'" >&2
            confirm "$args"
            return
            ;;
    esac
    echo "$emsg"
    return $retval
}

################################################################################
# initialize the utilities, define some useful hook(s)
# trap signal(s)
################################################################################
function __initialize__() {
    if ! typeset -f command_not_found_handle > /dev/null; then
        function command_not_found_handle() {
            echo "${SHELL:-bash}: $1: command not found"
        }
        declare -g command_not_found_handle=command_not_found_handle
    fi

    # test if function to declare already exists
    local func
    for func in EC man dict ips rename extract histop itunes; do
        if typeset -f $func > /dev/null; then
            echo "WARNING: ${func} is aleary exists"
        fi
    done

    # set trap to intercept the non-zero return code of last program
    function _err() {
        local status=$?
        local cmd
        cmd="$(history | tail -1 | sed -e 's/^ *[0-9]* *//')"
        log "command [${cmd}] execute failed with status [${status}]"
    }
    trap _err ERR

    # do some stuff before exit
    function _exit() {
        log "${USER} leaves $(tty)"
    }
    trap _exit EXIT
}
__initialize__
unset __initialize__

function man () {
	env \
	LESS_TERMCAP_mb=$'\E[01;31m' \
	LESS_TERMCAP_md=$'\E[01;34m' \
	LESS_TERMCAP_me=$'\E[00m' \
	LESS_TERMCAP_se=$'\E[00m' \
	LESS_TERMCAP_so=$'\E[31m' \
	LESS_TERMCAP_ue=$'\E[00m' \
	LESS_TERMCAP_us=$'\E[04;32m' \
	man "$@"
}

#########################################
# look up similar word(s) in *nix's dict
#########################################
function dict() {
    local word
    for word in "$@"; do
        grep "$word" /usr/share/dict/words
    done
}

################################################################################
# show ip addr and scope, etc about every NIC found
# depends on binary ip
################################################################################
function ips() {
    ip -family inet -oneline address show | perl -ne '
    {
        my @recs;
        sub addrec { push @recs, \@_; }
        sub fmtout {
            my $fmt = "%-8s%-8s%-20s%-16s%-s\n";
            foreach (@recs) { printf($fmt, @$_); }
        }
    }

    BEGIN { &addrec("Index", "Device", "IPv4 Address", "Broadcast", "Scope"); }

    { #sub main
        if (my ($index, $dev, $inet, $brd, $scope, $flags) = /^(\d+):\s+(\w+)\s+inet\s+([^\s]+)(?:\s+brd\s+([^\s]+)|)\s+scope\s+([^\\]+)\\\s+(.*)$/) {
            &addrec($index, $dev, $inet, defined($brd) ? $brd : " ", $scope);
        }
    }

    END { &fmtout(); }'
}

################################################################################
# extract file(s) from compressed status
# Parameter(s):
#   compressed files
################################################################################
function extract() {
    [ $# -eq 0 ] && echo "Usage: extract <archives>" && return 1
    while [ $# -gt 0 ]; do
	    if [ -f "$1" ]
	    then
		    case "$1" in
			  *.tar.bz2|*.tbz|*.tbz2) tar xjf "$1" ;;
			  *.tar.gz|*.tgz) tar xzf "$1" ;;
              *.tar.xz) xz --decompress "$1"; set -- "$@" "${1:0:-3}" ;;
              *.tar.Z) uncompress "$1"; set -- "$@" "${1:0:-2}" ;;
              *.pax.gz) gunzip "$1"; set -- "$@" "${1:0:-3}" ;;
              *.tar) tar xf "$1" ;;
			  *.bz2) bunzip2 "$1" ;;
			  *.rar) unrar x "$1" ;;
			  *.gz) gunzip "$1" ;;
			  *.zip|*.war|*.jar) unzip "$1" ;;
              *.Z) uncompress "$1" ;;
              *.txz) mv "$1" "${1:0:-4}.tar.xz"; set -- "$@" "${1:0:-4}.tar.xz" ;;
			  *.xz) xz --decompress "$1" ;;
              *.7z) 7za x "$1" ;;
              *.pax) pax -r -f "$1" ;;
              *.rpm) rpm2cpio "$1" | cpio -idmv ;;
              *.pkg) pkgutil --expand "$1" "${1:0:-4}" ;;
			  *) echo "'$1' cannot be extracted via extract" >&2 ;;
		    esac
	    else
		    echo "extract: '$1' is not a valid file" >&2
	    fi
        shift
    done
}

if [ -n "$BASH_VERSION" ]; then
    :
elif [ -n "$ZSH_VERSOIN" ]; then
    compdef '_files -g "*.gz *.tgz *.txz *.xz *.7z *.Z *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract
fi

# find a file with a pattern in name
function ff() {
    find . -type f -name '*'"$*"'*' -ls;
}

# find a file with pattern $1 in the name and Execute $2 on it
function fe() {
    find . -type f -name '*'"${1:-}"'*' \
        -exec ${2:-file} {} \; ;
}

# find a pattern in a set of files and highlight them
# see http://tldp.org/LDP/abs/html/sample-bashrc.html
function fstr() {
    local case="-I"
    local usage="fstr: find string in files.
Usage: fstr [-i] <pattern> <filename pattern>"

    if [ "$#" -lt 1 ]; then
        set -- "$@" "-h"
    fi
    local opt
    local OPTIND=1
    while getopts ":i" opt; do
        case "$opt" in
            i) case="-i" ;;
            *) echo "$usage" && return 1 ;;
        esac
    done
    shift $(($OPTIND-1))
    find . -type f -name "${2:-*}" -print0 | \
        xargs -0 egrep --color=auto -n ${case} "$1"
}

################################################################################
# Description:
#	History accepts a range in zsh entries as [first] [last] arguments, so to
#	get them all run history 1.
#	Note that the history list starts at 1 and not 0
#	print top command in history
# Globals:
#	None
# Arguments:
#	-h|-n <num>
# Returns:
#	None
################################################################################
function histop() {
    local opt
    local OPTIND=1
    while getopts "hn:" opt; do
        case "$opt" in
            h)
				cat <<-End-Of-Help
Usage: histop -n <num>
    num: print num lines of most used command
End-Of-Help
                return
                ;;
            n)
                if [[ $OPTARG =~ ^[1-9][0-9]*$ ]]; then
                    local -i n=$OPTARG
                else
                    echo "Option n needs an number" >&2
                    return 1
                fi
                ;;
            ?)
                histop -h >&2
                return 1
                ;;
        esac
    done
    shift $(($OPTIND-1))
	if [ $# -ne 0 ]; then
		echo "Unexpected parameter(s): '$@'"
		return 1
	fi

	fc -l -n 1 | perl -ane 'BEGIN {my %cmdlist}{$cmdlist{@F[0]}++}
	END {printf("Number\tTimes\tFrequency\tCommand\n");
	my ($i, $cnt) = (0, 0);
	foreach my $cmd (sort {$cmdlist{$b} <=> $cmdlist{$a}} keys %cmdlist) {
        last if ++$i > '"${n:-10}"';
        $cnt += $cmdlist{$cmd};
        printf("%-8d %-8d%6.2f%%\t%-16s\n", $i, $cmdlist{$cmd},
            $cmdlist{$cmd}*100/$., $cmd);
    }
    printf("%-8s%4d/%-4d%8.2f%%\t%-16s\n", "-", $cnt, $., $cnt*100/$., "");
	}'
}

###########################################################
# iTunes control function
# Options:
#   launch|play|pause|stop|rewind|resume
#   quit|mute|unmute|next|previous|help
# Returns:
#	None
###########################################################
function itunes() {
	local opt="$1"
	shift
	case "$opt" in
		launch|play|pause|stop|rewind|resume|quit)
			;;
		mute)
			opt="set mute to true"
			;;
		unmute)
			opt="set mute to false"
			;;
		next|previous)
			opt="$opt track"
			;;
		""|-h|--help)
            cat <<End-Of-Help
Usage: itunes <option>
    option:
        launch|play|pause|stop|rewind|resume|quit
        mute|unmute     control volume set
        next|previous   play next or previous track
        help            show this message and exit
End-Of-Help
			return
			;;
		*)
			print "Unkonwn option: $opt"
			return 1
			;;
	esac
	osascript -e "tell application \"iTunes\" to $opt"
}

################################################################################
# display apt-history
# Options:
#   help|install|upgrade|remove|list
# Returns:
#	None
# Note:
#   \<,\>: word boundary in regular expression
#   ref: http://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/special-chars.html
################################################################################
function apt-hist() {
	case "$1" in
		install|upgrade|remove)
            apt-hist list | grep --no-filename "\<$1\>"
			;;
		list)
            for log in $(ls -t /var/log/dpkg.log*); do
                [ -f "$log" ] || continue
                if [ ${log##*.} == gz ]; then
                    gunzip -c $log | tac
                else
                    tac $log
                fi
            done
			;;
		""|-h|--help)
			echo "Usage: apt-hist <help|install|upgrade|remove|rollback|list>"
            ;;
        *)
			print "Unkonwn option: $opt"
            apt-hist --help >&2
            return 1
            ;;
	esac
}

########################################################################
# perform uri_encode | uri_decode
# perl -MURI::Escape -e 'print uri_unescape();'
# Options:
#   ahp
########################################################################
function quote() {
    # candidate implementation
    #perl -MURI::Escape -e 'print uri_escape($ARGV[0]), "\n"' "$1"
    local opt="$1"
    local OPTIND=1
    while getopts "afFhpu" opt; do
        case "$opt" in
            a)
                local -r a=1
                ;;
            h)
                cat <<End-Of-Help
Usage: quote [option] [string]
    options:
        -a quote all characters
        -h show this help message and exit
        -p path quote
End-Of-Help
                return
                ;;
            p)
                local -r p=\/
                ;;
            ?)
                quote -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    local -r s="$1"
    local -r -i l=${#s}
    local t=''
    local c
    local o
    local -i i

    for ((i=0; i < l; ++i)); do
        c="${s:$i:1}"
        case "$c" in
            "$p"|"$a"[-_.~a-zA-Z0-9])
                o="$c"
                ;;
            *)
                o=$(echo -n "$c" | od -An -t x1 | tr '[ a-z]' '[%A-Z]')
                ;;
        esac
        t+="$o"
    done
    echo $t
}

function unquote() {
    printf '%b\n' "${1//%/\\x}" | tr '+' ' '
}

###########################################################
# use alias rm='trash' to play safer
# Globals:
#	HOME
# Options:
#   cdhlr
# Arguments:
#	file(s)
# Returns:
#	None
###########################################################
function trash() {
    local -r TRASHDIR="${HOME}/.local/share/Trash"
    local -r FILEDIR="${TRASHDIR}/files"
    local -r INFODIR="${TRASHDIR}/info"
    local opt="$1"
    local OPTIND=1
    while getopts "cd:hlr:" opt; do
        case "$opt" in
            c)
                local prompt='[trash] the clear operation cannot be undone'
                if confirm -p "${prompt}" -t 2 -d 1; then
                    rm -rf "${FILEDIR}/*"
                    rm -rf "${INFODIR}/*"
                else
                    echo "cancelled"
                fi
                return
                ;;
            d)
                echo "delete file '${OPTARG}'"
                return
                ;;
            h)
                echo "Usage: trash [option] [file]"
                return
                ;;
            l)
                echo -e "DeletionDate\tDeletionTime\tPath"
                for f in "${INFODIR}"/*.trashinfo; do
                    [ -f "$f" ] || continue
                    item="$(sed -ne '2h
                    3{G;s/DeletionDate=\(.*\)T\(.*\)\nPath=\(.*\)/\1\t\2\t\3/p;q}' "$f")"
                    printf '%b\n' "${item//%/\\x}"
                done
                return
                ;;
            r)
                echo "restore ${OPTARG} not supported yet"
                return
                ;;
            ?)
                trash -h >&2
                return 1
                ;;
        esac
    done
    shift $(($OPTIND-1))

    for item in "$@"; do
        local dst="${FILEDIR}/${item}"
        if [ -e "${dst}" ]; then
            local -i i=2
            while [ -e "${dst}.$i" ]; do
                let i=i+1
            done
            dst="${dst}.$i"
        fi
        cat <<EOT > "${INFODIR}/$(basename "${dst}").trashinfo"
[Trash Info]
Path=$(quote -p "$(readlink -e "${item}")"
DeletionDate=$(date "+%FT%T")
EOT
        if ! command mv -- "$item" "$dst"; then
            echo "failed to move file '${item}' to trash" >&2
            return 1
        fi
    done
}

function unix2dos() {
    [[ "$#" -eq 0 ]] && echo "Usage: unix2dos <file>" ||
    command perl -i -p -e 's/\n/\r\n/' "$1"
}

function dos2unix() {
    [[ "$#" -eq 0 ]] && echo "Usage: dos2unix <file>" ||
    command perl -i -p -e 's/\r\n/\n/' "$1"
}

if which tree >/dev/null 2>&1; then
function tree() {
    local opt
    local OPTIND=1
    while getopts "h" opt; do
        case "$opt" in
            h)
                cat <<End-Of-Help
Usage: tree [option] [directory]
End-Of-Help
                return
                ;;
            ?)
                tree -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))
    if [ $# -gt 1 ]; then
        echo "too many parameters" >&2
        return 1
    fi
    local dir="${1:-.}"
    echo "$dir"
    find "$dir" -print | sed -e 's#[^/]*/#|____#g
    s#____|#  |#g'
}
fi
###########################################################
# search google via command line
# Constans:
#	Google search url prefix
# Arguments:
#	keyword(s)
# Result(s):
#	open search result(s) in the default browser
###########################################################
function google() {
    local -r url="https://www.google.com.hk/search?hl=en#newwindow=1&q="
	case "$1" in
		"" | -h | --help)
			printf "google:\n\tgoogle <keyword>\n"
			exit 0
			;;
		*)
			while [ $# -ge 1 ]; do
				xdg-open "$url"$(echo ${1// /+} | xxd -plain | sed 's/\(..\)/%\1/g')
				shift
			done
			;;
	esac
}

function todo() {
    echo "see https://docs.python.org/3.2/library/dbm.html"
    cat <<End-Of-Usage
    "TODO: dbm"
    echo "Usage: todo <-l|-d|-c|-t|-n>"
    -l list
    -d delete
    -n create
    -c content
    -t title
End-Of-Usage
}

###########################################################
# dump var after tidle expand, command substitute, etc.
# Arguments:
#	anything
# Returns:
#	None
###########################################################
function vardump() {
	local -i i=0
	for arg; do
        i+=1
		echo "\$${i} => $arg"
		shift;
	done
}

# TODO: add apply, map, filter, reduce function
function apply() {
    if [ $# -ne 2 ]; then
        echo "Usage: apply input-cmd process-cmd" >&2
        return 1
    fi

    local item
    for item in $($1); do
        $2 "$item"
    done
}

function filter() {
    if [ $# -ne 2 ]; then
        echo "Usage: filter input-cmd filter-cmd" >&2
        return 1
    fi

    local item
    for item in $($1); do
        if $2 "$item"; then
            echo "$item"
        fi
    done
}
# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
