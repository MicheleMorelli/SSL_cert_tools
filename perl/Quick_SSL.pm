package Quick_SSL;

use strict;
use warnings;

use Exporter;
use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::Random;
use Crypt::OpenSSL::X509;
use DateTime;
use Net::SSLeay qw/sslcat/;

our @ISA = qw/ Exporter /;
our @EXPORT = qw/ $f /;

our $f = {};


$f->{ll} = sub {
    opendir my($dh), '.' or die "cannot open dir: $!"; 
    while ( readdir $dh){
        my $mode = (stat($_))[2]; 
        printf "%04o   $_\n", $mode & 07777;
    }
    closedir $dh;
};


$f->{make_private_key} = sub{
    my ( $SITECODE) = @_;
    # generating the private key
    my $rsa = Crypt::OpenSSL::RSA ->generate_key(2048)->get_private_key_string();
    open my $fh, '>', "$SITECODE.key" 
        or die "Cannot create private key $SITECODE.key: $!";
    print $fh $rsa;
    close $fh;
};


$f->{make_read_only} = sub{
    my ( $file) = @_;
    open my  $fh, '<', "$file" 
        or die "Cannot read key $file: $!";
    chmod 0400, $fh;
    close $fh;
};


$f->{pretty_subject} = sub {
    my ( $cert) = @_;
    my $subject = $cert->subject();
    
    # Subject() output format:
    #jurisdictionC=##, businessCategory=#################,
    #serialNumber=########,
    #C=##, ST=######, L=###########, O=################,
    #CN=###############
    
    $subject =~ m#(:?, )?C=(?<country>.*?), ST=(?<state>.*?), L=(?<location>.*?), O=(?<org_name>.*?), CN=(?<cn>.*)#gi;

    return "Common name: $+{cn}\nOrganisation name: $+{org_name}\nLocation: $+{location}\nState: $+{state}\nCountry: $+{country}";
};


$f->{will_expire_in_one_month} = sub{
    my ( $cert) = @_;
    my $one_month_in_seconds = 2592000;
    return $cert->checkend($one_month_in_seconds);
};


$f->{has_expired} = sub {
    my ( $cert) = @_;
    my $now = DateTime->now;
    
    # Current format:
    # Jun 15 13:23:00 2020 GMT
    $cert->notAfter() =~ m#([A-Za-z]{3}) (\d\d) \d{2}:\d{2}:\d{2} (\d{4})#gi;

    my $expiry_date = DateTime->new(
        day=> $2,
        month => $f->{give_month_number}($1),
        year => $3, 
    );

    return $expiry_date < $now ;
};


$f->{give_month_number} = sub {
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


$f->{get_cert_from_site} = sub {
    my ($url) = @_;
    my ($reply, $err, $cert) = sslcat($url, 443, '/');
    $cert = Net::SSLeay::PEM_get_string_X509( $cert);
#    open my $fh, '>', "TEST.crt";
#    print $fh $cert;
#    close $fh;
    return Crypt::OpenSSL::X509->new_from_string($cert);
};


$f->{get_cert_from_file} = sub {
    my ($SITECODE) = @_;
    my $cert =  Crypt::OpenSSL::X509->new_from_file("$SITECODE.crt") 
        or die "Cannot open certificate: $!";
    return $cert;
};


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

=head2 pretty_subject

Prints the subject of a SSL certificate.

=head2 has_expired

Checks if a SSL certificate has expired. 

=head2 give_month_number

Checks if a SSL certificate has expired. 

=head2 get_cert_from_site

Takes an URL as an argument, and returns an SSL certificate. 

=head2 get_cert_from_file

Returns an SSL cetificate from a file, and takes a sitecode as an argument. 

=cut
