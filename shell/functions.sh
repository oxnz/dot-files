# ~/.shell/functions.sh

if ! typeset -f command_not_found_handle > /dev/null; then
    function command_not_found_handle() {
        echo "${SHELL:-bash}: $1: command not found"
    }
fi

# test if function to declare already exists
for func in EC man dict ips rename extract histop itunes; do
    if typeset -f $func > /dev/null; then
        echo "WARNING: $func is aleary exists"
    fi
done

# set trap to intercept the non-zero return code of last program
#function _err() { echo -e '\e[1;31m'non-zero return code: $?'\e[m'; }
#trap _err ERR

# do stuff before exit
function _exit() {
    echo "bye"
}
trap _exit EXIT

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

# look words in nix's dict
function dict() {
	/usr/bin/grep "$@" /usr/share/dict/words
}

# show ip
function ips() {
    ip -family inet -oneline address show | perl -ne'BEGIN {
        my $fmt = "%-8s%-8s%-20s%-16s%-s\n";
        printf($fmt, "Index", "Device", "IPv4 Address", "Broadcast", "Scope");
    }

    my $fmt = "%-8s%-8s%-20s%-16s%-s\n";
    if (my ($index, $dev, $inet, $brd, $scope, $flags) = /^(\d+):\s+(\w+)\s+inet\s+([^\s]+)(?:\s+brd\s+([^\s]+)|)\s+scope\s+([^\\]+)\\\s+(.*)$/) {
        printf($fmt, $index, $dev, $inet, defined($brd) ? $brd : " ", $scope);
    }'
}

# extract files from compressed status
# TODO: test if the extract binary exists
# 	case $1 in
# 		*.tar.gz)	prog=tar args=xzf ;;
#	esac
#	if whence $prog
#		$prog $args $1
#	else
#		echo "extract needs $prog, but not exist"
#	fi
function extract() {
    [ $# -eq 0 ] && echo "Usage: extract <archives>" && return 1
    while (( $# > 0 )); do
	    if [[ -f $1 ]]
	    then
		    case $1 in
			  *.tar.bz2|*.tbz|*.tbz2) tar xjf $1 ;;
			  *.tar.gz|*.tgz) tar xzf $1 ;;
              *.tar.xz) xz --decompress $1; set -- $@ ${1:0:-3} ;;
              *.tar.Z) uncompress $1; set -- $@ ${1:0:-2} ;;
              *.pax.gz) gunzip $1; set -- $@ ${1:0:-3} ;;
              *.tar) tar xf $1 ;;
			  *.bz2) bunzip2 $1 ;;
			  *.rar) unrar x $1 ;;
			  *.gz) gunzip $1 ;;
			  *.zip|*.war|*.jar) unzip $1 ;;
              *.Z) uncompress $1 ;;
              *.txz) mv "$1" "${1:0:-4}.tar.xz"; set -- $@ "${1:0:-4}.tar.xz" ;;
			  *.xz) xz --decompress $1 ;;
              *.7z) 7za x $1 ;;
              *.pax) pax -r -f $1 ;;
              *.rpm) rpm2cpio $1 | cpio -idmv ;;
              *.pkg) pkgutil --expand $1 ${1:0:-4} ;;
			  *) echo "'$1' cannot be extracted via extract" 1>&2 ;;
		    esac
	    else
		    echo "extract: '$1' is not a valid file" 1>&2
	    fi
        shift
    done
}

if [ -n "$BASH_VERSION" ]; then
    :
elif [ -n "$ZSH_VERSOIN" ]; then
    compdef '_files -g "*.gz *.tgz *.txz *.xz *.7z *.Z *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract
fi

# Find a file with a pattern in name
function ff() {
    find . -type -iname '*'"$*"'*' -ls;
}

# Find a file with pattern $1 in the name and Execute $2 on it
function fe() {
    find . -type f -iname '*'"${1:-}"'*' \
        -exec ${2:-file} {} \; ;
}

# Find a pattern in a set of files and highlight them
# see http://tldp.org/LDP/abs/html/sample-bashrc.html
function fstr() {
    local case="-I"
    local usage="fstr: find string in files.
Usage: fstr [-i] <pattern> <filename pattern>"

    if [ "$#" -lt 1 ]; then
        set -- $@ "-h"
    fi
    local OPTIND=1
    local opt
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

# History accepts a range in zsh entries as [first] [last] arguments, so to
# get them all run history 1.
# Note that the history list starts at 1 and not 0
# print top command in history
function histop() {
    local opt
    local OPTIND=1
    while getopts ":hn:" opt; do
        case "$opt" in
            h)
				cat >&2 <<-End-Of-Help
Usage: histop -n <num>
    num: print num lines of most used command
End-Of-Help
                return 0
                ;;
            n)
                if [[ $OPTARG =~ ^[1-9][0-9]*$ ]]; then
                    local n=$OPTARG
                else
                    echo "Option n needs an number" >&2
                    return 1
                fi
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                return 1
                ;;
            :)
                echo "Option -$OPTARG requires an arguent." >&2
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

# iTunes control function
function itunes() {
	local opt=$1
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
			echo "Usage: itunes <option>"
			echo "option:"
			echo "\tlaunch|play|pause|stop|rewind|resume|quit"
			echo "\tmute|unmute\tcontrol volume set"
			echo "\tnext|previous\tplay next or previous track"
			echo "\thelp\tshow this message and exit"
			return 0
			;;
		*)
			print "Unkonwn option: $opt"
			return 1
			;;
	esac
	osascript -e "tell application \"iTunes\" to $opt"
}

# apt-history
function apt-hist() {
	case "$1" in
		install|upgrade|remove)
            apt-hist list | grep --no-filename " $1 "
			;;
		list)
            for log in $(ls -t /var/log/dpkg.log*); do
                if [ ${log##*.} == gz ]; then
                    gunzip -c $log | tac
                else
                    tac $log
                fi
            done
			;;
		*)
			echo "Usage: apt-hist <install|upgrade|remove|rollback|list>"
			return 1
            ;;
	esac
}

# use alias rm='trash' to play safer
function trash() {
	local TRASH
	case "$(uname -s)" in
		Darwin)
			TRASH=~/.Trash
			;;
		Linux)
			TRASH=~/.local/share/Trash/files
			;;
		*)
			echo "Unsupported system" 1>&2 && return 0
			;;
	esac
	case "$1" in
		""|-h|--help)
			echo "Usage: trash [files or directories]"
			;;
		*)
			for item in "$@"; do
				if [[ ! -e "$item" ]]; then
					echo "$item :No such file or directory, skipped" 1>&2
					# uncomment the following line to abort if non-exists
					#return 1
					continue
				fi
				local dst=${TRASH}/$(basename "$item")
				while [[ -e "$dst" ]]; do
					dst="${dst}+"
				done
				command mv -- "$item" "$dst"
			done
			;;
	esac
}

function unix2dos() {
    [[ "$#" -eq 0 ]] && echo "Usage: unix2dos <file>" ||
    command perl -i -p -e 's/\n/\r\n/' "$1"
}

function dos2unix() {
    [[ "$#" -eq 0 ]] && echo "Usage: dos2unix <file>" ||
    command perl -i -p -e 's/\r\n/\n/' "$1"
}

function google() {
	local url="https://www.google.com.hk/search?hl=en#newwindow=1&q="
	case "$1" in
		"" | -h | --help)
			printf "google:\n\tgoogle <keyword>\n"
			exit 0
			;;
		*)
			while [ $# -ge 1 ]; do
				/usr/bin/open "$url"$(echo ${1// /+} | xxd -plain | sed 's/\(..\)/%\1/g')
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

# dump var after tidle expand, command substitute, etc.
function vardump() {
	local -i i=0
	for arg
	do
		i+=1
		echo "\$${i} => $arg"
		shift;
	done
}

# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
