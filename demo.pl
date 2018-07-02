#! /usr/bin/perl -w

use strict;
use Quick_SSL;

#my $SITECODE = $ARGV[0];

my $c = Quick_SSL->new();

#$c->make_private_key("$SITECODE.key");
#$c->make_read_only("$SITECODE.key");
#TODO: make CSR!
#$c->ll();
#$c->print_sorted_expiry_dates("small.list")
my $cert = $c->get_cert_from_file("TEST.crt");
$c->make_email($cert);
