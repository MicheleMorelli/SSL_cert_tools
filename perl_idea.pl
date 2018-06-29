#! /usr/bin/perl -w
use strict;

use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::Random;
use Data::Dumper;

#TODO: test this module a bit

my $SITECODE = $ARGV[0];

# generating the private key
my $rsa = Crypt::OpenSSL::RSA ->generate_key(2048)->get_private_key_string();


open my $fh, '>', "$SITECODE.key" or die "Cannot create private key $SITECODE.key: $!";

print $fh $rsa;

close $fh;

print ("done\n");

