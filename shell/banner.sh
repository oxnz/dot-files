#!/bin/bash
# Author: Oxnz

# dispaly a message box with specific content and title
function msgbox() {
	if [ -t 0 ]; then
		echo "Read from stdin is not supported" >&2
		return 1;
	fi
	local OPTIND=1
	local opt
	local width=${COLUMNS:-80}
	while getopts ":a:c:e:f:hlm:nst:w:" opt; do
		case "$opt" in
			a)
				local align=$OPTARG
				;;
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
	-a specify content alignment l(eft)/m(iddle)/r(right), default is left
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

perl -ane '
#bc: border char, default is "|"
#pc: padding char, default is one space
sub colordump {
	print "colordump: \n";
	my ($line, $align, $bc, $pc) = @_;
	$align = "l" if not $align;
	$bc = "|" if not $bc;
	$pc = " " if not $pc;
	my $lw = $w - 4;
	$line =~ s/\n//;
	$line =~ s/\t/        /g;
	my $leftw = $lw;
	my $lastl = "";
	$line =~ s/(.*?)(?{
	my $len = length($1);
	if ($len < $leftw) {
		$lastl .= $1;
		$lw -= $len;
	} else {
		my $i = 0;
		print "${bc} " . $lastl, substr($1, $i, $lw), " ${bc}\n";
		$lastl = "";
		for ($i = $lw; $i <= $len; $i += $lw) {
			print "${bc} " . substr($1, $i, $lw) . " ${bc}\n";
		}
		$lastl = substr($1, $i, $lw);
		$leftw = $lw - length($lastl);
	}
	})(\e\[(?:\d{1,3};){0,3}\d{0,3}m)(?{
		#print $2;
	})//g;
}
sub linedump {
	my ($line, $align, $bc, $pc) = @_;
	$align = "l" if not $align;
	$bc = "|" if not $bc;
	$pc = " " if not $pc;
	my $lw = $w - 4;
	$line =~ s/\n//;
	$line =~ s/\t/        /g;
	my $len = length($line);
	for (my $i = 0; $i < int($len/$lw); ++$i) {
		printf("${bc} %s ${bc}\n", substr($line, $i*$lw, $lw));
	}
	my $tlen = $len % $lw;
	return if not $tlen;
	my $tail = substr($line, -$tlen);
	my $slen = $lw - $tlen;
	my $tailfmt = {
		l => "${bc} %-${lw}s ${bc}\n",
		m => "${bc} %+" . (($slen - $slen%2)/2 + $tlen) . "s" . "${pc}" x (($slen + $slen%2)/2) . " ${bc}\n",
		r => "${bc} %+${lw}s ${bc}\n"
	};
	printf($tailfmt->{$align}, $tail) if $tail;
}
BEGIN {
	$w = '"$width"';
	$_ = "_\\|/_";
	&linedump($_, "m", " ");
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
	$_ = "oOO-" . q/'"${mouth:-"{_}"}"'/ . "-OOo";
	$lw = $w - length() - 2;
	print "+", "-" x (($lw - $lw%2)/2), $_, "-" x (($lw + $lw%2)/2), "+\n";
	$_ = q/'"${${title//\//\\/}:-0}"'/;
	s/^'"'"'(.*)'"'"'$/$1/;
	for (split("\n")) {
		&linedump($_, "m");
	}
	printf("|%s|\n", "-" x ($w-2)) if $_;
}
{
	&linedump($_, q/'"${align:-l}"'/);
	&colordump($_, q/'"${align:-l}"'/) if /color/;
}
END {
	$_ = q/'"${${footer//\//\\/}:-0}"'/;
	s/^'"'"'(.*)'"'"'$/$1/;
	if ($_) {
		printf("|%s|\n", "-" x ($w-2));
		for (split("\n")) {
			&linedump($_, "l");
		}
	}
	printf("+%s+\n", "-" x ($w-2));
}'
}

# show banner
cat <<End-Of-Info | msgbox -t "Dashboard-$(uname -a)" -f "Uptime:$(uptime)"
Kernel: $(uname -r)
Uptime: $(uptime)
Mail: $(/usr/sbin/sendmail -bp)
Memory:
$(free -h)
Crontab:
M H D m W command
$(crontab -l 2>&1)
End-Of-Info

echo $'color:\e[01;31mhello f dsajfk sfjksaj fjsaf sjfasjfsa\e[00;32mworl fdsajkf sakf sakjf ksajfkjsadkf ksa fsajfsad\e[0m \e[01;33mhi, jfasjdkfjaks fjksajfjasfjksa fkas jfkjsafksa fksa fjsafas\e[00mjfkas fksa fsajfksaj fkdsa jfksa fsakj \e[34mjfdsakjfasf jas jfsajf sak jfsakj fa sjfakjs fksa jfksa jsa jfsa kjfkasdf kdsa fjksad jfkdsa \e[m' | msgbox
echo $'color:\e[01;31mhello \e[00;32mworld\e[0m \e[01;33mhi\e[00m' | msgbox | hexdump -C
