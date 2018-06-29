package perl_utils;

use strict;
use warnings;
use Exporter;

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

1;
