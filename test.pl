#!/usr/bin/env perl

use warnings;
use strict;

use Data::Dumper;
use strict;

my $del = qr/[^\\]\|/;
my $str = 'a\|b|c|d';
my @arr = split(/$del/, $str);
print $str . "\n";
print Dumper(@arr);
