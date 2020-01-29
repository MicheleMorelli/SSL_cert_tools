#! /usr/bin/perl -w

=begin comment
Just some potential example uses of the Quick_SSL package... 
=end comment
=cut


use strict;
use Quick_SSL;
use Data::Dumper;
#my $SITECODE = $ARGV[0];

my $c = Quick_SSL->new();

#$c->print_sorted_expiry_dates("list.list")
#my $cert = $c->get_cert_from_site("research.gold.ac.uk");
#$c->make_email("TEST.csr");

#print Dumper $c->get_subject("TEST.crt");
#print $cert->as_string();
