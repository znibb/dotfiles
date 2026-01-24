#!/bin/sh

# Get device name with `ratbagctl list`
DEVICE_NAME="Logitech G815 RGB MECHANICAL GAMING KEYBOARD"

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

if [[ "$1" != "M1" && "$1" != "M2" && "$1" != "M3" ]]; then
    echo "Error: Allowed values M1|M2|M3"
    exit 3
fi

current_profile=$(ratbagctl "$DEVICE_NAME" profile active get)

case "$1" in
    M1)
        if [[ "$current_profile" != 0 ]]; then
            ratbagctl "$DEVICE_NAME" profile active set 0
        fi
        ;;
    M2)
        if [[ "$current_profile" != 1 ]]; then
            ratbagctl "$DEVICE_NAME" profile active set 1
        fi
        ;;
    M3)
        if [[ "$current_profile" != 2 ]]; then
            ratbagctl "$DEVICE_NAME" profile active set 2
        fi
        ;;
    *)
        echo "Error: Unknown error"
        exit 4
esac