#!/bin/sh

# Get device name with `ratbagctl list`
DEVICE_NAME="Logitech Gaming Mouse G600"

# Check that ratbagctl is available
if ! command -v ratbagctl >/dev/null 2>&1; then
    echo "Error: ratbagctl missing"
    exit 1
fi

# 
if [ $# -eq 0 ]; then
    echo "Error: No argument provided"
    exit 2
fi

if [[ "$1" != "up" && "$1" != "down" ]]; then
    echo "Error: Allowed values up/down"
    exit 3
fi

current_profile=$(ratbagctl "$DEVICE_NAME" profile active get)

case "$1" in
    up)
        if [[ "$current_profile" == 0 ]]; then
            ratbagctl "$DEVICE_NAME" profile active set 1
        elif [[ "$current_profile" == 1 ]]; then
            ratbagctl "$DEVICE_NAME" profile active set 2
        fi
        ;;
    down)
        if [[ "$current_profile" == 2 ]]; then
            ratbagctl "$DEVICE_NAME" profile active set 1
        elif [[ "$current_profile" == 1 ]]; then
            ratbagctl "$DEVICE_NAME" profile active set 0
        fi
        ;;
esac