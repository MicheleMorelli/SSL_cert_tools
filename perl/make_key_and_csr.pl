#! /usr/bin/perl -w
use strict;

use Quick_SSL;

my $SITECODE = $ARGV[0];

$funct->{make_private_key}($SITECODE);
$funct->{make_read_only}($SITECODE);
#TODO: make CSR!
$funct->{ll}();
