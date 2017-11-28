FROM alpine:3.6

RUN apk add --update git
RUN git clone https://github.com/lukas2511/dehydrated /letsencrypt

RUN apk del git pcre expat

RUN apk add openssl curl bash jq

ADD parts/hook.sh /letsencrypt/hooks/cloudflare/hook.sh

ADD parts/go.sh /letsencrypt/run.sh

ADD parts/dig /usr/local/bin/dig

RUN rm -rf /var/cache/apk/*

ENTRYPOINT /letsencrypt/run.sh
