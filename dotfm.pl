#!/usr/bin/perl
package main;

our $VERSION = '0.01';

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

sub VERSION_MESSAGE {
	print "Version: $VERSION\n";
}

sub HELP_MESSAGE {
	print "HELP MESSAGE\n";
}

sub help {
	print "dotfm Dot File Manager\n";
}

sub pack {
	print "packing";
}

sub unpack() {
	my $file = $_[0];
	print "Unpacking [$file]\n";
}

BEGIN {
	my %opts = ();
	print "hello\n";
	print @ARGV;
	print "World\n";
	GetOptions( \%opts,
		'help|h!',
		'pack|p=s'		=> \%opts{'pack'},
		'unpack|u=s'	=> \%opts['unpack'],
		'config|c=s'	=> \%opts['config'],
		'version|v!',
	) or pod2usage(2);

	pod2usage(1) if $opts{'help'};
	&unpack("~/Desktop/x.tar.gz");


	print "BEGIN\n";
}

END {
	print "END\n";
}

__END__

=head1 NAME

dotfm.pl - Dot file manager

=head1 SYNOPSIS

dotfm.pl [options] -f <file>

Options:

	-h|help		print this help message and exit
	-p|pack		package dot files under ~
	-u|unpack	unpack dot files from specified package
	-f|file		package file to pack or pack from

=head1 OPTIONS

=over 8

=item B<-help>

Print this help message and exits.

=item B<-pack>

package dot files under ~ to a specified package file

=item B<-unpack>

unpack dot files to ~ from a specified package file

=back

=head1 DESCRIPTION

B<This program> will help to manage dot files under ~.

=cut
