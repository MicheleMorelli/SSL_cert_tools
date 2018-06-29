#! /usr/bin/perl -w
use strict;

use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::Random;
use Data::Dumper;

my $SITECODE = $ARGV[0];

# generating the private key
my $rsa = Crypt::OpenSSL::RSA ->generate_key(2048)->get_private_key_string();

open my $fh, '>', "$SITECODE.key" 
    or die "Cannot create private key $SITECODE.key: $!";

print $fh $rsa;

close $fh;


open  $fh, '<', "$SITECODE.key" 
    or die "Cannot read key $SITECODE.key: $!";

chmod 400, $fh;

close $fh;

my $func = {};

$func->{ll} = sub {
    opendir my($dh), '.' or die "cannot open dir: $!"; 
    while ( readdir $dh){
        my $mode = (stat($_))[2]; 
        printf "%04o   $_\n", $mode & 07777;
    }
    closedir $dh;
};

$func->{ll}();
