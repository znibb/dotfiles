#!/bin/bash

screen_dump="/tmp/screen.png"
grim $screen_dump
convert $screen_dump -scale 10% -scale 1000% $screen_dump
swaylock -C ~/.config/sway/swaylock.conf --image $screen_dump
