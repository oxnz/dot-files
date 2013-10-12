#!/usr/bin/perl
package main;

our $VERSION = '0.01';

use strict;
use warnings;
use File::Compare;
use File::Copy;
use Getopt::Long;
use Pod::Usage;
use Archive::Tar;

sub update() {
	my $sf = shift;
	my $df = shift;
	if (! -e $sf) {
		print "File: $sf does not exist\n";
		return 1;
	} elsif (! -r $sf) {
		print "File: $sf can not be read\n";
		return 1;
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
sub pack() {
	my $tarfile = shift;
	print "packing to: [$tarfile]\n";
	my $tar = Archive::Tar->new;
	$tar->add_files('zshrc', 'vimrc');
	$tar->write($tarfile, COMPRESS_GZIP);
}

BEGIN {
	my @flist = (
		"zshrc",
		"vimrc",
		"emacs",
		"gitconfig",
		"gitignore_global",
		"bash_profile",
		"vim/plugin/OxnzToolkit.vim",
		"vim/plugin/DoxygenToolkit.vim",
		"vim/doc/OxnzToolkit.txt",
		"shell/aliases",
		"shell/functions",
		"shell/switches",
	);
	my $pfile;
	my $help;
	GetOptions(
		"pack|p=s"	=> \$pfile,
		"help|h!"	=> \$help,
	) or pod2usage(2);

	if (defined($pfile)) {
		print "pack...\n";
		&pack($pfile);
	} else {
		for my $f (@flist) {
		&update(glob("~/.$f"), $f);
		}
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
	-man	full documentation

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=head1 DESCRIPTION

B<dotfm.pl> will read dot files under user's home directory and compare to the
specified directory, if differ, then copy to update.

=cut
