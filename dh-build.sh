#!/usr/bin/env bash
curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/tnwhitwell/letsencrypt.sh-cloudflare/trigger/${DOCKERHUB_TRIGGER_TOKEN}/
