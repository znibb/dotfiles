#!/bin/bash

PLAYER=spotify

STATUS=$(playerctl -p $PLAYER status)
ARTIST=$(playerctl -p $PLAYER metadata 'xesam:artist')
TITLE=$(playerctl -p $PLAYER metadata 'xesam:title')

case $1 in
  -j | --json)
    echo '{"status":"'"$STATUS"'","artist":"'"$ARTIST"'","title":"'"$TITLE"'","url":"'"$URL"'"}'
    ;;
  -w | --waybar)
    echo '{"text":"'"$ARTIST - $TITLE"'","class":"custom/spotify","alt":"'"$STATUS"'"}'
    ;;
  *)
    echo "$ARTIST - $TITLE"
esac
