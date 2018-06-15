#! /bin/bash

read -p "SITECODE: " SITECODE
openssl x509 -in $SITECODE.crt -noout -text | grep  "^\s*Subject:"
