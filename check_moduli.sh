# bin/bash


[[ $# -ne 1 ]] && echo 'ERROR: A sitecode must be passed as a value.
Terminating..' && exit 1
SITECODE=$1

[[ -e $SITECODE.crt ]] && CRT=$(openssl x509 -in $SITECODE.crt -noout -modulus | md5sum) 
[[ -e $SITECODE.key ]] && KEY=$(openssl rsa -in $SITECODE.key -noout -modulus | md5sum)
[[ -e $SITECODE.csr ]] && CSR=$(openssl req -in $SITECODE.csr -noout -modulus | md5sum)

[[ $CRT == $CRT ]] && echo "OK!"
