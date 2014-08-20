#!/bin/bash
# Author: Oxnz

function histop() {
fc -l -n 1 | perl -ane 'BEGIN {my %cmdlist = (); }
{ $cmdlist{@F[0]}++; print "@F[0]: $cmdlist{@F[0]}\n"}
	END {printf("Order\tTimes\tRatings\tCommand\n");
	my $i = 0;
	foreach my $cmd (sort { $cmdlist{$a} <=> $cmdlist{$b} } keys %cmdlist) {
		if (++$i > 10) {
			break;
		}
		printf("%-8d\t%-8d\t%-8.2f%%\t%-16s\n", $i, $cmdlist{$cmd}, $cmdlist{$cmd}*100/$., $cmd);
	}
	print "$.\n"; }'
	#awk 'BEGIN {} {for(i = 1; i <= NF; ++i) print $1;} END {print NR}'
  # 	| sort |\
  #  	uniq -c | sort -nr | head -n $n | awk -v histcnt="$histcnt" \
  #      'BEGIN {printf("Order\tTimes\tRatings\tCommand\n")}
  #  END {print histcnt}
  #  {printf("%-8d%-8d%-4.2f%%\t%-16s\n", FNR, $1, $1*100/histcnt, $2)}'
}

histop
