#! /usr/bin/perl -w

use strict;
use Quick_SSL;

my $SITECODE = $ARGV[0];

my $c = Quick_SSL->new();
#$c->make_private_key("$SITECODE.key");
#$c->make_read_only("$SITECODE.key");
#TODO: make CSR!
$c->ll();
