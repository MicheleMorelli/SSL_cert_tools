#! /bin/bash

# Checks whether the CRT, the KEY and the CSR have the same modulus.

# Check whether the sitecode was specified
[[ $# -ne 1 ]] && echo 'ERROR: A sitecode must be passed as a value. Terminating..' && exit 1

SITECODE=$1

[[ -e $SITECODE.crt ]] && CRT=$(openssl x509 -in $SITECODE.crt -noout -modulus | md5sum) 
[[ -e $SITECODE.key ]] && KEY=$(openssl rsa -in $SITECODE.key -noout -modulus | md5sum)
[[ -e $SITECODE.csr ]] && CSR=$(openssl req -in $SITECODE.csr -noout -modulus | md5sum)

[[ $CRT == $KEY ]] && [[ $CSR == $CRT ]] && [[ $KEY == $CSR  ]] && echo "The three moduli are matching.Success :-) " && exit 0

[[ $KEY == $CSR  ]] && [[ $KEY != "" ]] &&  [[ -e $SITECODE.crt ]] && echo "The KEY and the CSR are matching. However, the CRT is not there." && exit 1

echo "The moduli are not matching:"
echo "CSR: $CSR"
echo "CRT: $CRT"
echo "KEY: $KEY"
exit 1
