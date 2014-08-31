#!/bin/bash
# Author: Oxnz

function msgbox() {
	local OPTIND=1
	local opt
	local width=${COLUMNS:-80}
	while getopts ":c:e:f:hlm:nst:w:" opt; do
		echo "opt = $opt, val = $OPTARG"
		case "$opt" in
			c)
				local color=$OPTARG
				;;
			e)
				local eye=$OPTARG
				;;
			l)
				local list=true
				;;
			m)
				local mouth=$OPTARG
				;;
			n)
				local color='37;40' # white on black
				;;
			f)
				local footer=$OPTARG
				;;
			s)
				local single='37;40'
				;;
			t)
				local title=$OPTARG
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
msgbox <-e|-f|-t>
  Options:
	-c spcify ansi color code for eyes
	-e specify an eyestyle, a random one is used if not specified
	-f specify footer
	-h show this message and exit
	-l list all the eyestyles
	-m specify mouth style
	-n show inverse color, like ninja tutule\'s
	-s enable single-eye mode
	-t specify heading title
	-w set width
End-Of-Usage
				return 1
				;;
		esac
	done
	unset opt
	shift $(($OPTIND-1))

perl -ane 'BEGIN {
	$w = '"$width"';
	$_ = "_\\|/_";
	my $lw = $w - length();
	print " " x (($lw - $lw%2)/2), $_, " " x (($lw + $lw%2)/2), "\n";
	$_ = q/'"${eye:-0}"'/;
	if ($_) {
		$_ = "($_ $_)" if 1 == length();
	} else {
		my @ebs = qw(~ ! @ # $ % ^ & * - + = 1 4 6 8 9 0 o O '\'' " c e n v x z . < > ?);
		$_ = $ebs[int(rand(scalar(@ebs)))];
		$_ = "($_ $_)";
	}
	$lw = $w - length();
	my $single = q/'"${single:-0}"'/;
	my $color = q/'"${color:-0}"'/;
	if ($single) {
		substr($_, (1+length())/2, 0, "\e[${single}m");
		substr($_, length()-1, 0, "\e[m") if not $color;
	}
	$_ = "\e[${color}m$_\e[m" if $color;
	print " " x (($lw - $lw%2)/2), $_, " " x (($lw + $lw%2)/2), "\n";
	$_ = "oOO-{_}-OOo";
	$_ = "oOO-" . q/'"${mouth:-{_}}"'/ . "-OOo";
	$lw = $w - length() - 2;
	print "+", "-" x (($lw - $lw%2)/2), $_, "-" x (($lw + $lw%2)/2), "+\n";
	$_ = q/'"${title:-0}"'/;
	if ($_) {
		$lw = $w - length() - 2;
		print "|", " " x (($lw - $lw%2)/2), $_, " " x (($lw + $lw%2)/2), "|\n";
		printf("|%s|\n", "-" x ($w-2));
	}
}
{
	s/\n//;
	$len = length();
	$lw = $w - 4;
	for ($i = 0; $i < $len; $i += $lw) {
		my $line = substr($_, $i, $lw);
		printf("| %-${lw}s |\n", $line);
	}
}
END {
	$_ = q/'"${footer:-0}"'/;
	if ($_) {
		printf("|%s|\n", "-" x ($w-2));
		$lw = $w - length() - 4;
		printf("| %-${lw}s |\n", $_);
	}
	printf("+%s+\n", "-" x ($w-2));
}'
}
# show banner
cat <<End-Of-Info | msgbox -a fda -b -c -d "fda eda"
Kernel: $(uname -r)
Uptime: $(uptime)
Mail: $(/usr/sbin/sendmail -bp)
Memory:
$(free -h)
Crontab:
M H D m W command
$(crontab -l 2>&1)
End-Of-Info
