#!/usr/bin/perl
package main;
use vars (qw($VERSION),
          qw($file, $option)
         );

$VERSION = '0.01';

use strict;
use warnings;
use Getopt::Long;
use File::Copy;
use Data::Dumper;
use Pod::Usage;


sub scan {
	my $list = shift;
	print "list=$list\n";
	opendir(HOME, glob('~')) or die "Error in opening dir: ~\n";
	open(LIST, ">$list") or closedir(HOME) and
		die "Error in opening file: $list\n";
	while (readdir(HOME)) {
		next if $_ !~ m/^\./;
		next if $_ =~ m/^(\.|\.\.)$/;
		print LIST "$_\n";
	}
	close(LIST);
	closedir(HOME);
	return 0;
}

sub pack {
	my $list = shift;
	my $file = shift;
	print "packing from $list to $file\n";
	open(LIST, "<$list") or die "Error in opening file: $list\n";
	my $Home = glob('~');
	while(<LIST>) {
		chomp;
		my $f = $Home . "/" . $_;
		print "file:$f\n";
		copy($f, "/Users/xinyi/Desktop/tmp/$_") or warn "could not copy file: $f ($!)\n";
   }

}

sub readconfig {
	print "reading config\n";
}

sub compress {
	print "compressing\n";
}

BEGIN {
	print "BEGIN\n";
}

CHECK {
	print "CHECK\n";
}

INIT {
	print "INIT\n";
	my %opts = ();
	GetOptions(\%opts, qw(help|h! version|v! scan|s! pack|p! list|l=s  unpack|u! file|f=s))
		or die;
	print Dumper(\%opts);

	&scan($opts{list}) if defined $opts{scan};
	&pack($opts{list}, $opts{file}) if defined $opts{pack};
}

END {
	print "process END\n";
}

