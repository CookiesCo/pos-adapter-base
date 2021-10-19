#!/bin/bash

# From: https://stackoverflow.com/questions/7580508/getting-chrome-to-accept-self-signed-localhost-certificate
# (With modifications)

NAME=echo.local.cookies.co

echo "Cleaning existing keys...";
rm -fv ./*.crt ./*.key ./*.srl ./*.csr ./self*.conf ./self*.ext;

echo "Preparing self-signed keys...";

# Generate private key
openssl genrsa -out ./selfsigned-ca.key 2048

# Create a CA CSR configuration
>selfsigned-ca.conf cat <<-EOF
[ req ]
default_md = sha256
prompt = no
encrypt_key = no
distinguished_name = dn

[ dn ]
C = US
ST = California
L = San Francisco
O = Cookies Creative Consulting & Promotions, LLC
OU = Cookies Engineering
CN = Cookies Local Development Authority R0
EOF

# Generate root certificate
echo "Generating CA root...";
openssl req -x509 \
    -new \
    -nodes \
    -key ./selfsigned-ca.key \
    -sha256 \
    -days 825 \
    -config selfsigned-ca.conf \
    -out selfsigned-ca.crt;

######################
# Create CA-signed certs
######################

# Create a CSR configuration
>selfsigned.conf cat <<-EOF
[ req ]
default_md = sha256
prompt = no
encrypt_key = no
distinguished_name = dn
req_extensions = req_ext

[ dn ]
C = US
ST = California
L = San Francisco
O = Cookies Creative Consulting & Promotions, LLC
OU = Cookies Engineering
CN = $NAME

[ req_ext ]
subjectAltName = DNS:$NAME
EOF

echo "Generating certificate request...";
openssl req \
    -newkey ec:<(openssl genpkey -genparam -algorithm ec -pkeyopt ec_paramgen_curve:P-256) \
    -keyout selfsigned.key \
    -out selfsigned.csr \
    -config selfsigned.conf


# Create a config file for the extensions
>selfsigned.ext cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $NAME
DNS.2 = api.$NAME
EOF
# Create the signed certificate
openssl x509 -req -in selfsigned.csr -CA selfsigned-ca.crt -CAkey selfsigned-ca.key -CAcreateserial \
    -out selfsigned.crt -days 825 -sha256 -extfile selfsigned.ext

echo "Local keys ready.";
