# Quick SSL Certificate Tools #

This small API aims at making it easier to deal with SSL certificates-related tasks in a multi-tenancy service with a large number of websites / customers.

The these methods are based on openssl, and are developed in Perl (mostly) and
Bash.

## Dependencies

Some Perl dependecies are required to work.
You can install them via CPAN or, if on Ubuntu, just running the following command
should do the trick:

```
sudo apt install -y libcrypt-openssl-rsa-perl libcrypt-openssl-x509-perl libwww-perl libdatetime-perl libfile-slurp-perl
```

If you are using `yum` instead of `apt`, the following dependencies will be needed (please note that you might have to enable `epel-release` for some of them to be found):
```
perl-Crypt-OpenSSL-RSA
perl-Crypt-OpenSSL-X509
perl-DateTime-TimeZone
perl-Net-SSLeay
perl-File-Slurp
perl-Data-Dumper
```
