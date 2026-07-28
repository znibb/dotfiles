#!/bin/sh

# Can show compatible keys with `evtest`

# Configurable entities
# Button 0: G1
# Button 1: G2
# Button 2: G3
# Button 3: G4
# Button 4: G5
# Button 5: M1
# Button 6: M2
# Button 7: M3
# LED 0: G logo
# LED 1: Key backlight

# Get device name with `ratbagctl list`
DEVICE_NAME="Logitech G815 RGB MECHANICAL GAMING KEYBOARD"

# Check that ratbagctl is available
if ! command -v ratbagctl >/dev/null 2>&1; then
    echo "ratbagctl missing"
    exit 1
fi

# Set G1-5 to F13-17
## Profile 0
ratbagctl "$DEVICE_NAME" profile 0 button 0 action set macro KEY_F13
ratbagctl "$DEVICE_NAME" profile 0 button 1 action set macro KEY_F14
ratbagctl "$DEVICE_NAME" profile 0 button 2 action set macro KEY_F15
ratbagctl "$DEVICE_NAME" profile 0 button 3 action set macro KEY_F16
ratbagctl "$DEVICE_NAME" profile 0 button 4 action set macro KEY_F17

## Profile 1
ratbagctl "$DEVICE_NAME" profile 1 button 0 action set macro KEY_F13
ratbagctl "$DEVICE_NAME" profile 1 button 1 action set macro KEY_F14
ratbagctl "$DEVICE_NAME" profile 1 button 2 action set macro KEY_F15
ratbagctl "$DEVICE_NAME" profile 1 button 3 action set macro KEY_F16
ratbagctl "$DEVICE_NAME" profile 1 button 4 action set macro KEY_F17

## Profile 2
ratbagctl "$DEVICE_NAME" profile 2 button 0 action set macro KEY_F13
ratbagctl "$DEVICE_NAME" profile 2 button 1 action set macro KEY_F14
ratbagctl "$DEVICE_NAME" profile 2 button 2 action set macro KEY_F15
ratbagctl "$DEVICE_NAME" profile 2 button 3 action set macro KEY_F16
ratbagctl "$DEVICE_NAME" profile 2 button 4 action set macro KEY_F17

# Set M1-M3 to F18-F20
## Profile 0
ratbagctl "$DEVICE_NAME" profile 0 button 5 action set macro KEY_F18
ratbagctl "$DEVICE_NAME" profile 0 button 6 action set macro KEY_F19
ratbagctl "$DEVICE_NAME" profile 0 button 7 action set macro KEY_F20

## Profile 1
ratbagctl "$DEVICE_NAME" profile 1 button 5 action set macro KEY_F18
ratbagctl "$DEVICE_NAME" profile 1 button 6 action set macro KEY_F19
ratbagctl "$DEVICE_NAME" profile 1 button 7 action set macro KEY_F20

## Profile 2
ratbagctl "$DEVICE_NAME" profile 2 button 5 action set macro KEY_F18
ratbagctl "$DEVICE_NAME" profile 2 button 6 action set macro KEY_F19
ratbagctl "$DEVICE_NAME" profile 2 button 7 action set macro KEY_F20

# LED colours
## Profile 0
ratbagctl "$DEVICE_NAME" profile 0 led 0 set mode on
ratbagctl "$DEVICE_NAME" profile 0 led 0 set color 00ffff
ratbagctl "$DEVICE_NAME" profile 0 led 1 set mode on
ratbagctl "$DEVICE_NAME" profile 0 led 1 set color 00ffff

## Profile 1
ratbagctl "$DEVICE_NAME" profile 1 led 0 set mode on
ratbagctl "$DEVICE_NAME" profile 1 led 0 set color ff00ff
ratbagctl "$DEVICE_NAME" profile 1 led 1 set mode on
ratbagctl "$DEVICE_NAME" profile 1 led 1 set color ff00ff

## Profile 2
ratbagctl "$DEVICE_NAME" profile 2 led 0 set mode on
ratbagctl "$DEVICE_NAME" profile 2 led 0 set color ffff00
ratbagctl "$DEVICE_NAME" profile 2 led 1 set mode on
ratbagctl "$DEVICE_NAME" profile 2 led 1 set color ffff00