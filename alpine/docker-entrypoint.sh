#!/bin/sh

sed -i "s/DOMAIN/${DOMAIN}/g" site.cnf
sed -i "s/SITE_IP/${SITE_IP}/g" site.cnf

openssl genrsa -out "/ssl/${DOMAIN}.key" 4096

openssl req -new -key "/ssl/${DOMAIN}.key" -out "site.csr" -sha256 \
         -subj "/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=${DOMAIN}"
openssl x509 -req -days 750 -in "site.csr" -sha256 \
         -CA "root-ca.crt" -CAkey "root-ca.key"  -CAcreateserial \
         -out "/ssl/${DOMAIN}.crt" -extfile "site.cnf" -extensions server

cp /srv/root-ca.crt /ssl
