package Quick_SSL;

use strict;
use warnings;
use Exporter;
use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::Random;

=pod
=head1 Quick_SSL
This functions are aimed at dealing open_SSL-related tasks in a quick and 
automated way.
=cut

our @ISA = qw/ Exporter /;
our @EXPORT = qw/ $funct /;

our $funct = {};


=pod
=head2 ll
Similar to Bash's ls -l, shows the files in the . directory and shows the 
read/write permissions.
=cut
$funct->{ll} = sub {
    opendir my($dh), '.' or die "cannot open dir: $!"; 
    while ( readdir $dh){
        my $mode = (stat($_))[2]; 
        printf "%04o   $_\n", $mode & 07777;
    }
    closedir $dh;
};


$funct->{make_private_key} = sub{
    my ( $SITECODE) = @_;
    # generating the private key
    my $rsa = Crypt::OpenSSL::RSA ->generate_key(2048)->get_private_key_string();
    open my $fh, '>', "$SITECODE.key" 
        or die "Cannot create private key $SITECODE.key: $!";
    print $fh $rsa;
    close $fh;
};


$funct->{make_read_only} = sub{
    my ( $SITECODE) = @_;
    open my  $fh, '<', "$SITECODE.key" 
        or die "Cannot read key $SITECODE.key: $!";
    chmod 0400, $fh;
    close $fh;
};

1;
