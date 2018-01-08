FROM alpine:latest

RUN apk add --no-cache openssl \
    && mkdir /ssl

COPY *.cnf root-ca.crt root-ca.key /srv/

WORKDIR /ssl

ENV DOMAIN=docker.domain.com SITE_IP=127.0.0.1

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
