# bin/bash

read -p "SITECODE:" SITECODE

openssl x509 -in $SITECODE.crt -noout -modulus | md5sum
openssl rsa -in $SITECODE.key -noout -modulus | md5sum
openssl req -in $SITECODE.csr -noout -modulus | md5sum
