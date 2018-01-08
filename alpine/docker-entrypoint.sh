#!/bin/sh

sed -i "s/DOMAIN/${DOMAIN}/g" site.cnf
sed -i "s/SITE_IP/${SITE_IP}/g" site.cnf

ca_root(){
  cd /srv
  echo "[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash" > root-ca.cnf

  openssl genrsa -out "root-ca.key" 4096 \

  openssl req \
             -new -key "root-ca.key" \
             -out "root-ca.csr" -sha256 \
             -subj '/C=CN/ST=Shanxi/L=Datong/O=ZZZ-khs1994-docker/CN=khs1994.com CA/OU=www.khs1994.com' \

  openssl x509 -req  -days 3650  -in "root-ca.csr" \
             -signkey "root-ca.key" -sha256 -out "root-ca.crt" \
             -extfile "root-ca.cnf" -extensions \
             root_ca
}

if [ "$1" = 'root_ca' ];then
  ca_root
  cp /srv/root-ca.crt /ssl
  exit 0
fi

if ! [ -f /srv/root-ca.crt ];then
  ca_root
fi

openssl genrsa -out "/ssl/${DOMAIN}.key" 4096

openssl req -new -key "/ssl/${DOMAIN}.key" -out "site.csr" -sha256 \
         -subj "/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=${DOMAIN}"

openssl x509 -req -days 750 -in "site.csr" -sha256 \
         -CA "root-ca.crt" -CAkey "root-ca.key"  -CAcreateserial \
         -out "/ssl/${DOMAIN}.crt" -extfile "site.cnf" -extensions server

cp /srv/root-ca.crt /ssl
