docker run --rm -it \
    --name="letsencrypt" \
    --entrypoint="/letsencrypt/dehydrated" \
    -v $(pwd)/accounts:/letsencrypt/accounts \
    -v $(pwd)/certs:/letsencrypt/certs \
    -v $(pwd)/domains.txt:/letsencrypt/domains.txt:ro \
    tnwhitwell/letsencrypt.sh-cloudflare \
    --register --accept-terms
