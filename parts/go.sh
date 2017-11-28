#!/bin/bash
cd /letsencrypt
./dehydrated -c -g -t dns-01 -k 'hooks/cloudflare/hook.sh'
