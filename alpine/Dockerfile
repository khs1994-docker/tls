FROM alpine:latest

RUN apk add --no-cache openssl

COPY *.cnf root-ca.crt /srv/

WORKDIR /ssl

ENV DOMAIN=docker.domain.com SITE_IP=127.0.0.1

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
