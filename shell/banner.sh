#!/bin/bash
# Author: Oxnz

# dispaly a message box with specific content and title
function msgbox() {
	local OPTIND=1
	local opt
	local width=${COLUMNS:-80}
	while getopts ":a:c:e:f:hlm:nsSt:w:" opt; do
		case "$opt" in
			a)
				local align=$OPTARG
				;;
			c)
				local color=$OPTARG
				;;
			e)
				local eye=${OPTARG//\//\\\/}
				;;
			l)
				local list=true
				;;
			m)
				local mouth=${OPTARG//\//\\\/}
				;;
			n)
				local color='37;40' # white on black
				;;
			f)
				local footer=${OPTARG//\//\\\/}
				;;
			s)
				local single='37;40'
				;;
			S)
				local strip=true
				;;
			t)
				local title=${OPTARG//\//\\\/}
				;;
			w)
                if [[ $OPTARG =~ ^[1-9][0-9]*$ ]]; then
                    width=$OPTARG
                else
                    echo "Option w needs an number" >&2
                    return 1
                fi
                ;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				return 1
				;;
			:)
				echo "Option -$OPTARG requires an argument." >&2
				return 1
				;;
			*)
				cat >&2 <<\End-Of-Usage
msgbox [OPTIONS]... [FIELD]...
  Options:
	-a specify content alignment l(eft)/m(iddle)/r(right), default is left
	-c spcify ansi color code for eyes
	-e specify an eyestyle, a random one is used if not specified
	-f specify footer
	-h show this message and exit
	-l list all the eyestyles
	-m specify mouth style
	-n show inverse color, like ninja tutule\'s
	-s enable single-eye mode
	-S strip color codes and other non-printable characters
	-t specify heading title
	-w set width
End-Of-Usage
				return 1
				;;
		esac
	done
	unset opt
	shift $(($OPTIND-1))
	if [ -t 0 ]; then
		echo "Read from stdin is not supported" >&2
		return 1;
	fi

perl -ane '
#bc: border char, default is "|"
#pc: padding char, default is one space
sub colordump {
	my ($line, $align, $bc, $pc) = @_;
	$align = "l" if not $align;
	$bc = "|" if not $bc;
	$pc = " " if not $pc;
	my $lw = $w - length("${bc}${pc}") * 2;
	my ($leftw, $lastl) = ($lw, "");
	$line =~ s/\n$//;
	$line =~ s/\t/        /g;
	for (split /(\e\[(?:\d{1,3};){0,3}\d{0,3}m)/, $line) {
		if ("\e" eq substr($_, 0, 1)) {
			$color = $_;
		} else {
			my $len = length();
			if ($len < $leftw) {
				$lastl .= "$color$_\e[m";
				$leftw -= $len;
			} else {
				$lastl .= $color . substr($_, 0, $leftw) . "\e[m";
				print "${bc}${pc}${lastl}${pc}${bc}\n";
				my $i = $leftw;
				$len -= $leftw;
				$leftw = $len % $lw;
				for (; $i < $len - $leftw; $i += $lw) {
					$lastl = $color . substr($_, $i, $lw) . "\e[m";
					print "${bc}${pc}${lastl}${pc}${bc}\n";
				}
				$lastl = substr($_, $i, $lw);
				$lastl = $color . $lastl if $leftw;
				$leftw = $lw - $leftw;
			}
		}
	}
	my $tailfmt = {
		l => "${bc}${pc}%-s" . ($pc x $leftw) . "${pc}${bc}\n",
		m => "${bc}${pc}" . ($pc x (($leftw - $leftw%2)/2)) . "%s" . ($pc x (($leftw + $leftw%2)/2)) . "${pc}${bc}\n",
		r => "${bc}${pc}" . ($pc x $leftw) . "%+s${pc}${bc}\n"
	};
	printf($tailfmt->{$align}, "${lastl}\e[m") if $lastl;
}
sub plaindump {
	my ($line, $align, $bc, $pc) = @_;
	$align = "l" if not $align;
	$bc = "|" if not $bc;
	$pc = " " if not $pc;
	my $lw = $w - length("${bc}${pc}") * 2;
	$line =~ s/\n//;
	$line =~ s/\t/        /g;
	$line =~ s/\e\[(?:\d{1,3};){0,3}\d{0,3}m//g;
	my $len = length($line);
	for (my $i = 0; $i < int($len/$lw); ++$i) {
		printf("${bc} %s ${bc}\n", substr($line, $i*$lw, $lw));
	}
	my $tlen = $len % $lw;
	return if not $tlen;
	my $tail = substr($line, -$tlen);
	my $slen = $lw - $tlen;
	my $tailfmt = {
		l => "${bc}${pc}%-${lw}s${pc}${bc}\n",
		m => "${bc}${pc}" . ("${pc}" x (($slen - $slen%2)/2)) . "%+s" . ("${pc}" x (($slen + $slen%2)/2)) . "${pc}${bc}\n",
		r => "${bc}${pc}%+${lw}s${pc}${bc}\n"
	};
	printf($tailfmt->{$align}, $tail) if $tail;
}
BEGIN {
	$w = '"$width"';
	$linedump = \&colordump;
	if (q/'"${strip:-0}"'/) {
		$linedump = \&plaindump;
	}
	$_ = "_\\|/_";
	$linedump->($_, "m", " ");
	if ($_ = q/'"${eye:-0}"'/) {
		$_ = "($_ $_)" if 1 == length();
	} else {
		my @ebs = qw(~ ! @ # $ % ^ & * - + = 1 4 6 8 9 0 o O '\'' " c e n v x z . < > ?);
		$_ = $ebs[int(rand(scalar(@ebs)))];
		$_ = "($_ $_)";
	}
	$color = q/'"${color:-0}"'/;
	if (my $single = q/'"${single:-0}"'/) {
		substr($_, (1+length())/2, 0, "\e[${single}m");
		substr($_, length()-1, 0, "\e[m") if not $color;
	}
	$_ = "\e[${color}m$_\e[m" if $color;
	$color = "";
	$linedump->($_, "m", " ");
	$_ = "oOO-" . q/'"${mouth:-"{_}"}"'/ . "-OOo";
	$linedump->($_, "m", "+", "-");
	if ($_ = q/'"${title:-0}"'/) {
		for (split("\n")) {
			$linedump->($_, "m");
		}
		$linedump->("-", "m", "|", "-");
	}
}
{
	$linedump->($_, q/'"${align:-l}"'/);
}
END {
	$color = "";
	if ($_ = q/'"${footer:-0}"'/) {
		$linedump->("-", "m", "|", "-");
		for (split("\n")) {
			$linedump->($_, "l");
		}
	}
	$linedump->("-", "m", "+", "-");
}'
}

# show banner
function banner() {
	echo "\e[32mKernel:\e[m $(uname -r)"
	echo "\e[33mUptime:\e[m $(uptime)"
	echo "\e[34mMail:\e[m $(/usr/sbin/sendmail -bp 2>&1)"
	echo "\e[35mMemory:\e[m"
	echo "$(free -h)"
	echo "\e[31mCrontab:\e[m"
	echo "\e[36mM H D m W command\e[m"
	echo "$(crontab -l 2>&1)"
}

banner | msgbox -t "$(uname -a)" -f "Uptime:$(uptime)"
