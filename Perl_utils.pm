package Perl_utils;

use strict;
use warnings;
use Exporter;
use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::Random;

our @ISA = qw/ Exporter /;
our @EXPORT = qw/ $funct /;

our $funct = {};


$funct->{ll} = sub {
    opendir my($dh), '.' or die "cannot open dir: $!"; 
    while ( readdir $dh){
        my $mode = (stat($_))[2]; 
        printf "%04o   $_\n", $mode & 07777;
    }
    closedir $dh;
};


$funct->{make_private_key} = sub{
    my ($SITECODE) = @_;
    # generating the private key
    my $rsa = Crypt::OpenSSL::RSA ->generate_key(2048)->get_private_key_string();
    open my $fh, '>', "$SITECODE.key" 
        or die "Cannot create private key $SITECODE.key: $!";
    print $fh $rsa;
    close $fh;
}


$funct->{make_read_only} = sub{
    my ($SITECODE) = @_;
    open  $fh, '<', "$SITECODE.key" 
        or die "Cannot read key $SITECODE.key: $!";
    chmod 0400, $fh;
    close $fh;
}

1;
