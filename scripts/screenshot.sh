#!/bin/bash

FILENAME="screenshot-`date +%F_%T`"
mkdir -p ~/Pictures/screenshots
grim -g "$(slurp)" ~/Pictures/screenshots/$FILENAME.png
