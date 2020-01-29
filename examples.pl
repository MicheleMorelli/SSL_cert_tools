#! /usr/bin/perl -w

use strict;
use FindBin;
use lib "$FindBin::Bin/lib";
use Quick_SSL;

=begin comment
Just some potential example uses of the Quick_SSL package... 

my $c = Quick_SSL->new();

$c->print_sorted_expiry_dates("list_filename.txt")
my $cert = $c->get_cert_from_site("www.example.com");
$c->make_email("TEST.csr");

print Data::Dumper::Dumper $c->get_subject("TEST.crt");
print $cert->as_string();

=end comment
=cut
