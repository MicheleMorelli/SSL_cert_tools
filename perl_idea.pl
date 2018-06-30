#! /usr/bin/perl -w
use strict;

use Perl_utils;

my $SITECODE = $ARGV[0];

$funct->{make_private_key}($SITECODE);
$funct->{make_read_only}($SITECODE);
$funct->{ll}();
