#!/bin/bash

CMD_TIMEOUT=${CMD_TIMEOUT_SECS:-5}

while true; do

  timeout $CMD_TIMEOUT coap -q coap://${COAP_HOST}/status 2>&1 > /dev/null

  if [ $? -ne 0 ]; then
    SERVER=$(penctl ${PENCTL_HOST} servers | grep $HOST_IP | awk '{ print $1 }')
    penctl ${PENCTL_HOST} server ${SERVER} blacklist 60
  fi

  sleep ${TIMEOUT_SECS:-30}
done
