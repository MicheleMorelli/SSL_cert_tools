#! /usr/bin/perl -w

use strict;
use Quick_SSL;
use GetOpt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);

my $SITECODE = $ARGV[0];

$f->{make_private_key}($SITECODE);
$f->{make_read_only}($SITECODE);
#TODO: make CSR!
$f->{ll}();
