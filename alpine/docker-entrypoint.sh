#!/bin/sh

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

if [ "$1" = 'sh' ] || [ "$1" = bash ];then
  exec /bin/sh
  exit 0
fi

if [ "$1" = 'root_ca' ];then
  ca_root
  cp /srv/root-ca.crt /srv/root-ca.key /ssl
  exit 0
fi

if ! [ -f /srv/root-ca.crt ];then echo "ROOT CA ERROR"; exit 1;fi
if ! [ -f /srv/root-ca.key ];then echo "ROOT CA ERROR"; exit 1;fi


rm -rf /ssl/*

sed -i "s/DOMAIN/${DOMAIN}/g" /srv/site.cnf
sed -i "s/SITE_IP/${SITE_IP}/g" /srv/site.cnf

openssl genrsa -out "/ssl/${DOMAIN}.key" 4096

openssl req -new -key "/ssl/${DOMAIN}.key" -out "/ssl/site.csr" -sha256 \
         -subj "/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=${DOMAIN}"

openssl x509 -req -days 750 -in "/ssl/site.csr" -sha256 \
         -CA "/srv/root-ca.crt" -CAkey "/srv/root-ca.key"  -CAcreateserial \
         -out "/ssl/${DOMAIN}.crt" -extfile "/srv/site.cnf" -extensions server

cp /srv/root-ca.crt /ssl

rm -rf /ssl/*.csr
