#!/bin/bash
# Checks diskspace of the root drive and sends ntfy alerts with varying degrees
# of priority depending on the available disk space

diskSpace=$(df / --output='pcent' | grep -o "[0-9]*")

export NTFY_TOPIC=ceres
export NTFY_TITLE="Ceres almost out of disk space!"
export NTFY_MESSAGE="Storage is $diskSpace% full."

if [ $diskSpace -ge 90 ]; then
        NTFY_PRIORITY=5 ntfy pub
elif [ $diskSpace -ge 70 ]; then
        NTFY_PRIORITY=4 ntfy pub
elif [ $diskSpace -ge 50 ]; then
        NTFY_PRIORITY=3 ntfy pub
fi
