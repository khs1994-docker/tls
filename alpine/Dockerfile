FROM alpine:latest

RUN apk add --no-cache openssl

COPY *.cnf /srv/

WORKDIR /srv

RUN openssl genrsa -out "root-ca.key" 4096 \
      && openssl req \
           -new -key "root-ca.key" \
           -out "root-ca.csr" -sha256 \
           -subj '/C=CN/ST=Shanxi/L=Datong/O=ZZZ-khs1994-docker/CN=khs1994.com CA/OU=www.khs1994.com' \
      && openssl x509 -req  -days 3650  -in "root-ca.csr" \
           -signkey "root-ca.key" -sha256 -out "root-ca.crt" \
           -extfile "root-ca.cnf" -extensions \
           root_ca

ENV DOMAIN=docker.domain.com

ENV SITE_IP=127.0.0.1

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
