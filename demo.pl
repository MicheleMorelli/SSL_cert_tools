#! /usr/bin/perl -w

use strict;
use Quick_SSL;
use Data::Dumper;
#my $SITECODE = $ARGV[0];

my $c = Quick_SSL->new();

#$c->print_sorted_expiry_dates("list.list")
#my $cert = $c->get_cert_from_site("research.gold.ac.uk");
#$c->make_email($cert);

print $c->get_subject("TEST.csr");
#print $cert->as_string();
