#!/bin/bash
cd /letsencrypt.sh
./letsencrypt.sh -c -g -t dns-01 -k 'hooks/cloudflare/hook.sh'
