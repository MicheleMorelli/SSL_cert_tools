# bin/bash


[[ $# -ne 1 ]] && echo 'ERROR: A sitecode must be passed as a value.
Terminating..' && exit 1
SITECODE=$1

[[ -e $SITECODE.crt ]] && CRT=$(openssl x509 -in $SITECODE.crt -noout -modulus | md5sum) 
[[ -e $SITECODE.key ]] && KEY=$(openssl rsa -in $SITECODE.key -noout -modulus | md5sum)
[[ -e $SITECODE.csr ]] && CSR=$(openssl req -in $SITECODE.csr -noout -modulus | md5sum)

[[ $CRT == $KEY ]] && [[ $CSR == $CRT ]] && [[ $KEY == $CSR  ]] && echo "The three
moduli are matching.Success :-) " && exit 0

echo "The moduli are not matching:"
echo "CSR: $CSR"
echo "CRT: $CRT"
echo "KEY: $KEY"
exit 1
