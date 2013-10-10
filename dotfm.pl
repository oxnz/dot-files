#!/usr/bin/perl
package main;

our $VERSION = '0.01';

use strict;
use warnings;
use File::Compare;
use File::Copy;
use Getopt::Long;
use Pod::Usage;

sub update() {
	my $sf = shift;
	my $df = shift;
	if (compare($sf, $df)) {
		print "updating file: $df\n";
		copy($sf, $df) or die $!;
	}
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
	for my $f (@flist) {
		&update(glob("~/.$f"), $f);
	}
}

END {
}
