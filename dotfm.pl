#!/usr/bin/perl
package main;

our $VERSION = '0.02';

use strict;
use warnings;
use File::Compare;
use File::Copy;
use File::Basename;
use File::Path;
use Getopt::Long;
use Pod::Usage;
use Archive::Tar;

sub update() {
	my $sf = shift;
	my $df = shift;
	for my $f ($sf, $df) {
		if (! -e $sf) {
			print "File: $sf does not exist\n";
			return 1;
		} elsif (! -r $sf) {
			print "File: $sf can not be read\n";
			return 1;
		}
	}
	if ( (-e $sf) && (-r $sf) ) {
		if (compare($sf, $df)) {
			print "updating file: $df\n";
			copy($sf, $df) or die $!;
		}
		return 0;
	}
}

# packup dotfiles to a tar.gz file
# @arguments:
# 	tarfile: archive file name
# 	flistref: ref to file list
sub pack() {
	my $tarfile = shift;
	my $h = shift;
	print "start packing\n";
	my $tar = Archive::Tar->new;
	for (@{$h}) {
		print "adding=> [$_]\n";
	}
	$tar->add_files(@{$h});
	print "write to file => [$tarfile]\n";
	$tar->write($tarfile, COMPRESS_GZIP);
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
		if (compare($sf, $df)) {
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
		"zshrc",
		"vimrc",
		"emacs",
		"gitconfig",
		"gitignore",
		"bash_profile",
		"vim/plugin/OxnzToolkit.vim",
		"vim/plugin/DoxygenToolkit.vim",
		"vim/doc/OxnzToolkit.txt",
		"emacs.d/init.el",
		"shell/aliases",
		"shell/functions",
		"shell/switches",
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
		for my $f (@flist) {
			&update(glob("~/.$f"), $f);
		}
	} elsif (defined($deploy)) {
		for my $f (@flist) {
			&deploy($f, glob("~/.$f"));
		}
	} else {
		pod2usage(0);
	}
}

END {
}

__END__

=head1 NAME

dotfm - dot files diff and copy program

=head1 SYNOPSIS

Options:
	-pack	<filename>
	-update
	-deploy
	-help
	-man	full documentation

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

=head1 DESCRIPTION

B<dotfm.pl> will read dot files under user's home directory and compare to the
specified directory, if differ, then copy to update.

=cut
