#! /usr/bin/perl -w
use strict;

use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::Random;
use Data::Dumper;

#TODO: test this module a bit
print Crypt::OpenSSL::RSA ->generate_key(2048)->get_private_key_string();


