#! /usr/bin/perl -

use strict;
use diagnostics;
use Test::More qw/ no_plan /;
use Data::Dumper;
use Quick_SSL;

is($f->{get_cert_from_file}("TEST"), $f->{get_cert_from_site}("www.google.com") );
