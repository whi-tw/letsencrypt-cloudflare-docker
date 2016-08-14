FROM alpine:3.4

RUN apk add --update git
RUN git clone https://github.com/lukas2511/letsencrypt.sh /letsencrypt.sh

RUN apk add openssl curl bash jq

RUN curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v9.10.2/dig.tgz|tar -xzv -C /usr/local/bin/

ADD hook.sh /letsencrypt.sh/hooks/cloudflare/hook.sh
RUN chmod +x /letsencrypt.sh/hooks/cloudflare/hook.sh

ADD go.sh /letsencrypt.sh/run.sh
RUN chmod +x /letsencrypt.sh/run.sh

RUN rm -rf /var/cache/apk/*

ENTRYPOINT /letsencrypt.sh/run.sh
