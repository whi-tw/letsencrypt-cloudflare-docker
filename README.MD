## Synopsis

A docker container which handles letsencrypt certificate creation and renewal. Also on [Docker Hub](https://hub.docker.com/r/tnwhitwell/letsencrypt.sh-cloudflare/ "Docker Hub")

## Code Example

Should be run with:

    docker run --rm -it \
    --name="letsencrypt.sh" \
    -e CF_EMAIL='<CLOUDFLARE_EMAIL>' \
    -e CF_KEY='<CLOUDFLARE_KEY>' \
    -v letsencrypt.sh/accounts:/letsencrypt.sh/accounts \
    -v letsencrypt.sh/certs:/letsencrypt.sh/certs \
    -v letsencrypt.sh/domains.txt:/letsencrypt.sh/domains.txt:ro \
    tnwhitwell/letsencrypt.sh-cloudflare

The mapped volumes (/letsencrypt.sh/accounts, /letsencrypt.sh/certs, /letsencrypt.sh/domains.txt) should be mapped somewhere static. The certificates will be created in the /certs folder.

## Installation

    git pull https://github.com/tnwhitwell/letsencrypt-cloudflare-docker
    cd letsencrypt-cloudflare-docker
    cp run.sh.example run.sh
    
    open run.sh in an editor
    edit "<CLOUDFLARE_EMAIL>" and "<CLOUDFLARE_KEY>" to match your cloudflare account
    
    cp domains.txt.example domains.txt
    open domains.txt in an editor
    enter domains, one line per certificate, with SAN names as per:

    example.com alternate.com subdomain.example.com

    ./run.sh
    


## Credits

Dig for Alpine:
https://github.com/sequenceiq/docker-alpine-dig/

Inspiration for script:
https://github.com/kappataumu/letsencrypt-cloudflare-hook
