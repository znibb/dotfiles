#!/bin/bash

INTERFACE_NAME=vpn-home

STATUS_CONNECTED_STR='{"text":"Connected","class":"connected","alt":"connected"}'
STATUS_DISCONNECTED_STR='{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'

function wg-active() {
  sudo wg show | grep -E '^interface: ' > /dev/null 2>&1
  return $?
}

function wg-toggle() {
  wg-active && sudo wg-quick down $INTERFACE_NAME > /dev/null 2>&1 || sudo wg-quick up $INTERFACE_NAME > /dev/null 2>&1
}

case $1 in
  -s | --status)
    wg-active && echo $STATUS_CONNECTED_STR || echo $STATUS_DISCONNECTED_STR
    ;;
  -t | --toggle)
    wg-toggle
    ;;
esac
