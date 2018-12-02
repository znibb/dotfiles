#!/bin/bash

lock_image="$HOME/wallpapers/lock.png"
tar_file="/tmp/screen.png"

scrot $tar_file
convert $tar_file -scale 10% -scale 1000% $tar_file

if [[ -f $lock_image ]] 
then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    R=$(file $lock_image | grep -o '[0-9]* x [0-9]*')
    RX=$(echo $R | cut -d' ' -f 1)
    RY=$(echo $R | cut -d' ' -f 3)

    SR=$(xrandr --query | grep ' connected' | sed 's/primary //' | cut -f3 -d' ')
    for RES in $SR
    do
        # monitor position/offset
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))

        convert $tar_file $lock_image -geometry +$PX+$PY -composite -matte  $tar_file
        echo "done"
    done
fi
# -u no unlock indicator 
i3lock -e -n -i $tar_file
