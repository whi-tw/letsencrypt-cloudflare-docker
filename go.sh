#!/bin/bash
cd /letsencrypt.sh
./letsencrypt.sh -c -t dns-01 -k 'hooks/cloudflare/hook.sh'
