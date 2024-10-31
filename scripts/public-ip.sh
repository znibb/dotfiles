#!/bin/bash

IP=$(curl -s ifconfig.me/ip)

case $1 in
  -j | --json)
    echo '{"public-ip":"'"$IP"'"}'
    ;;
  -w | --waybar)
    echo '{"text":"'"$IP"'","class":"custom/public-ip"}'
    ;;
  *)
    echo $IP
    ;;
esac
