#! /usr/bin/perl -

use strict;
use diagnostics;
use Test::More qw/ no_plan /;
use Data::Dumper;
use Quick_SSL;


# Checking if the 2 get_cert methods return the same cert
is( $f->{get_cert_from_file}("TEST.crt")->as_string(), 
    $f->{get_cert_from_site}("www.cosector.com")->as_string(),
    "Is it the same cert?"    
);


# pretty subject test
is ($f->{pretty_subject}($f->{get_cert_from_file}("TEST.crt")),
    $f->{pretty_subject}($f->{get_cert_from_site}("www.cosector.com")),
    "Is pretty subject the same?"
);


# pretty subject test 2
is ($f->{pretty_subject}($f->{get_cert_from_file}("TEST.crt")),
    "Common name: *.squarespace.com\nOrganisation name: Squarespace, Inc., OU=Web Services\nLocation: New York\nState: New York\nCountry: US",
    "Is the pretty subject string the same?"
);
