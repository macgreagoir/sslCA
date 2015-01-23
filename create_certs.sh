#!/bin/bash
# Create SSL certs for 'gobstack'
# TODO Pass in a label, other than gobstack, as an arg.
#
# Comments refer to use of these certs in an OpenStack deployment.
# reset.sh will delete certs and reset the index and serial count.

# Required files and directories
[ -f index.txt ] || touch index.txt
[ -f serial ] || echo 1000 > serial
for d in certs newcerts private; do
    [ -d "$d" ] || mkdir $d
done

# Create a CA
# ca_certs = /etc/keystone/ssl/certs/ca.pem
# ca_key = /etc/keystone/ssl/private/cakey.pem
# passwd must be >= six chars
openssl req -new -x509 -days 3650 -extensions v3_ca -keyout private/cakey.pem -out cacert.pem -config openssl.cnf 

# Create a signing request
# keyfile = /etc/keystone/ssl/private/signing_key.pem
openssl req -new -nodes -outform PEM -keyform PEM -out gobstack_signing_cert_req.pem -keyout private/gobstack_signing_key.pem -config openssl.cnf

# Create a signed cert
# certfile = /etc/keystone/ssl/certs/signing_cert.pem
openssl ca -config openssl.cnf -out gobstack_cert.pem -infiles gobstack_signing_cert_req.pem

# RabbitMQ wants a PKCS#1 key
openssl rsa -in private/gobstack_signing_key.pem -out private/gobstack_rsa_signing_key.pem

# For all openstack services
# gobstack_cert.pem is cert.pem
# gobstack_signing_key.pem is key.pem
