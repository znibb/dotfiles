#!/bin/bash

FILENAME="screenshot-`date +%F_%T`"
grim -g "$(slurp)" ~/Pictures/screenshots/$FILENAME.png
