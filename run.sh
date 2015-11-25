#!/bin/bash

TIMEOUT=${TIMEOUT_SECS:-30}
CMD_TIMEOUT=${CMD_TIMEOUT_SECS:-5}
BLACKLIST_TIMEOUT=${BLACKLIST_TIMEOUT_SECS:-120}

healthcheck() {
  local blacklist_timeout
  blacklist_timeout=0
  SERVER=$1
  SERVER_NUMBER=$(echo ${SERVER} | awk '{ print $1 }')
  SERVER_IP=$(echo ${SERVER} | awk '{ print $3 }')
  SERVER_PORT=$(echo ${SERVER} | awk '{ print $5 }')

  timeout $CMD_TIMEOUT coap -q coap://${SERVER_IP}:${SERVER_PORT}/status 2>&1 > /dev/null
  if [ $? -ne 0 ]; then
    blacklist_timeout=${BLACKLIST_TIMEOUT}
  fi
  penctl ${PENCTL_HOST} server ${SERVER_NUMBER} blacklist $blacklist_timeout
}

main() {
  while true; do
    local servers
    SERVERS_RAW=$(penctl ${PENCTL_HOST} servers)
    IFS=$'\n' read -rd '' -a servers <<<"$SERVERS_RAW"

    for server in "${servers[@]}"; do
      healthcheck "${server}"
    done

    sleep ${TIMEOUT}
  done
}
main
