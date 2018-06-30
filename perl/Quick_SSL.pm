package Quick_SSL;

use strict;
use warnings;
use Exporter;
use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::Random;
use Crypt::OpenSSL::X509;
use DateTime;
use Date::Parse;
use Date::Language;

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


$funct->{print_subject} = sub {
    my ( $SITECODE) = @_;
    my $cert =  Crypt::OpenSSL::X509->new_from_file("TEST.crt") 
        or die "Cannot open certificate: $!";
    print $cert->subject();
};


$funct->{check_expired} = sub {
    my ( $SITECODE) = @_;
    my $cert =  Crypt::OpenSSL::X509->new_from_file("TEST.crt") 
        or die "Cannot open certificate: $!";
    my $now = DateTime->now;
    
    # Current format:
    # Jun 15 13:23:00 2020 GMT
    $cert->notAfter() =~ m#([A-Za-z]{3}) (\d\d) \d{2}:\d{2}:\d{2} (\d{4})#gi;

    my $expiry_date = DateTime->new(
        day=> $2,
        month => $funct->{give_month_number}($1),
        year => $3, 
    );

    print $expiry_date;
};


$funct->{give_month_number} = sub {
    my ($month) = @_;
    
    my $month_names = {
        Jan => 1,
        Feb => 2,
        Mar => 3,
        Apr => 4,
        May => 5,
        Jun => 6,
        Jul => 7,
        Aug => 8,
        Sep => 9,
        Oct => 10,
        Nov => 11,
        Dec => 12,
    };

    return $month_names->{$month};
};

$funct->{check_expired}();

1;


__END__


=pod

=head1 Quick SSL

This functions are aimed at dealing open_SSL-related tasks in a quick 
and automated way.

=head2 ll

Similar to bash's ls -l, it prints the contents of the working directory,
including the read/write privileges.

=head2 make_private_key

Generates a private key and stores it in a .key file.

=head2 make_read_only

Makes a file read only (chmod 400).

=head2 print subject

Prints the subject of a SSL certificate.

=head2 check_expired

Checks if a SSL certificate has expired. 

=head2 give_month_number

Checks if a SSL certificate has expired. 

=cut
