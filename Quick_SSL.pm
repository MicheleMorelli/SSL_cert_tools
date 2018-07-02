package Quick_SSL;

use strict;
use warnings;

use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::Random;
use Crypt::OpenSSL::X509;
use DateTime;
use Net::SSLeay qw/sslcat/;


sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
}

sub ll {
    my $self = shift;
    opendir my($dh), '.' or die "cannot open dir: $!"; 
    while ( readdir $dh){
        my $mode = (stat($_))[2]; 
        printf "%04o   $_\n", $mode & 07777;
    }
    closedir $dh;
}


sub make_private_key {
    my $self = shift;
    my ( $key_name) = @_;
    # generating the private key
    my $rsa = Crypt::OpenSSL::RSA ->generate_key(2048)->get_private_key_string();
    open my $fh, '>', "$key_name" 
        or die "Cannot create private key $key_name: $!";
    print $fh $rsa;
    close $fh;
}


sub make_read_only {
    my $self = shift;
    my ( $file) = @_;
    open my  $fh, '<', "$file" 
        or die "Cannot read key $file: $!";
    chmod 0400, $fh;
    close $fh;
}


sub pretty_subject  {
    my $self = shift;
    my ( $cert) = @_;
    my $subject = $cert->subject();
    
    # Subject() output format:
    #jurisdictionC=##, businessCategory=#################,
    #serialNumber=########,
    #C=##, ST=######, L=###########, O=################,
    #CN=###############
    
    $subject =~ m#(:?, )?C=(?<country>.*?), ST=(?<state>.*?), L=(?<location>.*?), O=(?<org_name>.*?), CN=(?<cn>.*)#gi;

    return "Common name: $+{cn}\nOrganisation name: $+{org_name}\nLocation: $+{location}\nState: $+{state}\nCountry: $+{country}";
}


sub will_expire_in_one_month {
    my $self = shift;
    my ( $cert) = @_;
    my $one_month_in_seconds = 2592000;
    return $cert->checkend($one_month_in_seconds);
}


sub get_expiry_datetime {
    my $self = shift;
    my ($cert) = @_;
    # Current format:
    # Jun 15 13:23:00 2020 GMT
    $cert->notAfter() =~ m#([A-Za-z]{3}) +(\d\d?) \d{2}:\d{2}:\d{2} (\d{4})#gi;
    return DateTime->new(
        day=> $2,
        month => $self->give_month_number($1),
        year => $3,
    );
}


sub has_expired {
    my $self = shift;
    my ( $cert) = @_;
    my $now = DateTime->now;
    my $expiry_date = $self->get_expiry_datetime($cert);
    return $expiry_date < $now ;
}


sub give_month_number {
    my $self = shift;
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
    print STDERR $month." is not in $month_names>>>>>>" unless exists $month_names->{$month};
    return $month_names->{$month};
}


sub get_cert_from_site {
    my $self = shift;
    my ($url) = @_;
    my ($reply, $err, $cert) = sslcat($url, 443, '/');
    $cert = Net::SSLeay::PEM_get_string_X509( $cert);
#    open my $fh, '>', "TEST.crt";
#    print $fh $cert;
#    close $fh;
    return (defined $cert) ? Crypt::OpenSSL::X509->new_from_string($cert) : $cert;
}


sub get_cert_from_file {
    my $self = shift;
    my ($cert_file) = @_;
    my $cert =  Crypt::OpenSSL::X509->new_from_file($cert_file) 
        or die "Cannot open certificate: $!";
    return $cert;
}


sub get_urls_from_file {
    my $self = shift;
    my ($file) = @_;
    my @urls = ();
    open my $fh, '<', $file 
        or die "Cannot open $file:$!";
    while (my $line=<$fh>){
        chomp($line);
        push @urls, $line;
    } 
    return @urls;
}

sub get_all_certs_expiry_dates {
    my $self = shift;
    my ($file) = @_;
    my $SSL_certs = {};
    for my $site ($self->get_urls_from_file($file)){
        print STDERR "Now processing $site\n";
        my $cert = $self->get_cert_from_site($site);
        # skips the site if it is not https
        next unless defined $cert;
        $SSL_certs->{$site} = $self->get_expiry_datetime($cert);
    }
    #returns a hash where they sites FQDNs are the keys, and the datestamps
    #the values.
    return $SSL_certs;
}


sub print_sorted_expiry_dates {
    my ($self, $list_file) = @_;
    my $expiry_dates = $self->get_all_certs_expiry_dates($list_file);
    for my $key (sort {$expiry_dates->{$a} <=> $expiry_dates->{$b}} keys %$expiry_dates){
        print $self->pretty_datetime( $expiry_dates->{$key} )." =======> ".$key."\n";
    }
}


sub pretty_datetime {
    my ($self, $dt) = @_;
    my $day_padding = ($dt->day < 10) ? 0 :"";
    my $month_padding = ($dt->month < 10) ? 0 :"";
    my $pretty_dt = $day_padding.$dt->day."-".$month_padding.$dt->month."-".$dt->year;
    return $pretty_dt;
}


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

=head2 get_urls_from_file

Takes a file containing a list of urls, and returns a @list of urls.

=head2 get_all_certs_expiry_dates

Returns the expiry dates of all the sites as a hashref.

=head2 print_sorted_expiry_dates

Sorts the hashref containing the FQDNS and the expiry dates of the certificate associated to it, and prints them.

=head2 pretty_datetime

Takes a datetime object as an argument, and returns a a string in the dd-mm-yyyy 
format.

=cut
