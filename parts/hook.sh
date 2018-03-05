#!/usr/bin/env bash
function _debug() {
  if [[ $DEBUG ]]
  then
    echo " + $*"
  fi
}

function _info() {
  echo " + $*"
}

function _cf_get {
  local URL="${1}"
  curl -s -X GET "https://api.cloudflare.com/client/v4/$URL" -H "X-Auth-Email: $CF_EMAIL" -H "X-Auth-Key: $CF_KEY" -H "Content-Type: application/json"
}

function _check_DNS {
  local NAME="${1}"
  dig +short TXT $NAME @8.8.8.8 | sed 's/"//g'
}

# https://api.cloudflare.com/#zone-list-zones
function _get_zone_id {
  local DOMAIN="${1}"
  len=$(($(echo $DOMAIN | tr '.' ' ' | wc -w)-1))
  for i in $(seq $len)
  do
    result=$(_cf_get "zones?name=$DOMAIN")
    id=$(echo $result | jq -r '.result[0].id')
    if [ "$id" != "null" ]
    then
      echo $id
      return
    fi
    DOMAIN=$(echo $DOMAIN | cut -d "." -f 2-)
  done
}

#https://api.cloudflare.com/#dns-records-for-a-zone-dns-record-details
function _get_txt_record_id {
  local ZONE_ID="${1}" NAME="${2}" TOKEN="${3}"
  result=$(_cf_get "zones/$ZONE_ID/dns_records?type=TXT&name=$NAME&content=$TOKEN")
  echo $result | jq -r '.result[0].id'
}

# https://api.cloudflare.com/#dns-records-for-a-zone-create-dns-record
function deploy_challenge {
  local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"
  _debug "Creating Challenge: $1: $3"
  ZONE_ID=$(_get_zone_id $DOMAIN)
  _debug "Got Zone ID $ZONE_ID"
  NAME="_acme-challenge.$DOMAIN"

  result=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" -H "X-Auth-Email: $CF_EMAIL" -H "X-Auth-Key: $CF_KEY" -H "Content-Type: application/json" --data "{\"type\":\"TXT\",\"name\":\"$NAME\",\"content\":\"$TOKEN_VALUE\",\"ttl\":1}")
  RECORD_ID=$(echo $result | jq -r '.result.id')
  _debug "TXT record created, ID: $RECORD_ID"

  _info "Settling down for 10s..."
  sleep 10

  while [ "$(_check_DNS $NAME)" != "$TOKEN_VALUE" ]
  do
    _info "DNS not propagated, waiting 30s..."
    sleep 30
  done

}

#https://api.cloudflare.com/#dns-records-for-a-zone-delete-dns-record
function clean_challenge {
  local DOMAIN="${1}" TOKEN="${3}"

  if [ -z "$DOMAIN" ]
  then
    _info "http_request() error in letsencrypt.sh?"
    return
  fi

  ZONE_ID=$(_get_zone_id $DOMAIN)
  _debug "Got Zone ID $ZONE_ID"
  NAME="_acme-challenge.$DOMAIN"
  RECORD_ID=$(_get_txt_record_id $ZONE_ID $NAME $TOKEN)
  _debug "Deleting TXT record, ID: $RECORD_ID"

  result=$(curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" -H "X-Auth-Email: $CF_EMAIL" -H "X-Auth-Key: $CF_KEY" -H "Content-Type: application/json")
}

function deploy_cert {
  local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}" TIMESTAMP="${6}"
  _info "ssl_certificate: $CERTFILE"
  _info "ssl_certificate_key: $KEYFILE"
}

function unchanged_cert {
  return
}

function invalid_challenge {
  return
}

function request_failure {
  return
}

function startup_hook {
  return
}

function exit_hook {
  return
}

# check environmental vars
[ -z "$CF_EMAIL" ] && echo "Need to set CF_EMAIL" && exit 1
[ -z "$CF_KEY" ] && echo "Need to set CF_KEY" && exit 1

HANDLER="$1"; shift
if [[ "${HANDLER}" =~ ^(deploy_challenge|clean_challenge|deploy_cert|unchanged_cert|invalid_challenge|request_failure|startup_hook|exit_hook)$ ]]; then
  "$HANDLER" "$@"
fi
