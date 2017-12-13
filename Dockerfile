FROM alpine:latest

RUN apk add --no-cache openssl

COPY *.cnf /src/

ENV DOMAIN=docker.domain.com

ENV YOUR_IP=127.0.0.1

RUN cd /src \
      && sed -i "s/DOMAIN/${DOMAIN}/g" site.cnf \
      && sed -i "s/YOUR_IP/${YOUR_IP}/g" site.cnf \
      && cat site.cnf \
      && openssl genrsa -out "root-ca.key" 4096 \
      && openssl req \
           -new -key "root-ca.key" \
           -out "root-ca.csr" -sha256 \
           -subj '/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=Your Company Name Docker Registry CA' \
      && openssl x509 -req  -days 3650  -in "root-ca.csr" \
           -signkey "root-ca.key" -sha256 -out "root-ca.crt" \
           -extfile "root-ca.cnf" -extensions \
           root_ca \
      && openssl genrsa -out "${DOMAIN}.key" 4096 \
      && openssl req -new -key "${DOMAIN}.key" -out "site.csr" -sha256 \
           -subj "/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=${DOMAIN}" \
      && openssl x509 -req -days 750 -in "site.csr" -sha256 \
           -CA "root-ca.crt" -CAkey "root-ca.key"  -CAcreateserial \
           -out "${DOMAIN}.crt" -extfile "site.cnf" -extensions server \
      && mkdir ${DOMAIN} \
      && mv ${DOMAIN}.key ${DOMAIN}.crt ${DOMAIN} \
      && mv ${DOMAIN} / \
      && cd / \
      && tar -zcvf ${DOMAIN}.tar.gz ${DOMAIN} \
      && rm -rf /src/* ${DOMAIN}
