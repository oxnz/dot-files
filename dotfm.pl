#!/usr/bin/perl
#
# Copyright (c) 2013-2021 Will Z
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

package main;

use strict;
use warnings;

our $VERSION = '0.04';

use File::Compare;
use File::Copy;
use File::Basename;
use File::Path;
use Getopt::Long;
use Pod::Usage;

sub update() {
	my $sf = shift;
	my $df = shift;
	my $tdir = dirname($df);
	if (! -e $sf) {
		print "File: $sf does not exist\n";
		return 1;
	} elsif (! -r $sf) {
		print "File: $sf can not be read\n";
		return 1;
	}

	if (! -e $tdir) {
		print "Making directory: $tdir\n";
		mkdir($tdir);
	}

	if ( -d $sf) {
		if (! -e $df) {
			print "updating directory: $df\n";
			mkdir($df) or die $!;
		}
	} elsif (compare($sf, $df)) {
		print "updating file: $df\n";
		copy($sf, $df) or die $!;
	}
	return 0;
}

# packup dotfiles to a tar.gz file
# @arguments:
# 	tarfile: archive file name
# 	flistref: ref to file list
sub pack() {
	require Archive::Tar;
	my $tarfile = shift;
	my $h = shift;
	print "start packing\n";
	my $tar = Archive::Tar->new;
	for (@{$h}) {
		print "adding=> [$_]\n";
	}
	$tar->add_files(@{$h});
	print "write to file => [$tarfile]\n";
	$tar->write($tarfile, Archive::Tar->COMPRESS_GZIP);
}

sub deploy() {
	my $sf = shift;
	my $df = shift;
	my $fname = basename($df);
	my $dname = dirname($df);
	if (! -d $dname) {
		mkpath($dname);
	}
	if ( (-e $sf) && (-r $sf) ) {
		if (-d $sf) {
			if (! -e $df) {
				print "deploy directory: $df\n";
				mkdir($df) or die $!;
			}
		} elsif (compare($sf, $df)) {
			print "deploy file: $df\n";
			copy($sf, $df) or die $!;
		}
	}
}

BEGIN {
	# signal handler
	$SIG{TERM} = $SIG{INT} = sub {
		my $sig = shift;
		print "SIGNAL: $sig\n";
	};
	my @flist = (
		"emacs",
		"emacs.d",
		"gitconfig",
		"gitignore",
		"pythonrc",
		"vimrc",
		"vim/*/*",
	);
	my $help;
	my $pfile;
	my $update;
	my $deploy;
	GetOptions(
		"help|h!"	=> \$help,
		"update|u!" => \$update,
		"pack|p=s"	=> \$pfile,
		"deploy|d!" => \$deploy,
	) or pod2usage(2);

	if (defined($help)) {
		pod2usage(0);
	} elsif (defined($pfile)) {
		&pack($pfile, \@flist);
	} elsif (defined($update)) {
		# prefix len
		my $len = length(glob("~/") . ".");
		for my $p (@flist) {
			for my $f (glob("~/.$p")) {
				&update($f, substr($f, $len));
			}
		}
	} elsif (defined($deploy)) {
		my $len = length(glob("~/") . ".");
		for my $p (@flist) {
			for my $f (glob($p)) {
				&deploy($f, glob("~/.$f"));
			}
		}
	} else {
		pod2usage(0);
	}
}

END {
}

__END__

=pod

=encoding utf8

=head1 NAME

dotfm - dot files manager

=head1 SYNOPSIS

=head2 Options:

-pack <filename>
-update
-deploy
-help
man

=head1 OPTIONS

=over 8

=item B<-p --pack>
Pack dot-files to a tar.gz file

=item B<-u --update>
Update dot-files

=item B<-d --deploy>
Deploy dot-files to home directory

=item B<-h --help>
Print a brief help message and exits.

=back

=head1 DESCRIPTION

B<dotfm.pl> will read dot files under user's home directory and compare to the
specified directory, if differ, then copy to update.

=head1 BUGS

Bugs report address: L<https://github.com/oxnz/dot-files>

=cut
