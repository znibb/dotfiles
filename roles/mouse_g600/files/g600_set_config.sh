#!/bin/sh

# Can show compatible keys with `evtest`

# Configurable entities
# Button 0: Left click
# Button 1: Right click
# Button 2: Middle click
# Button 3: Scroll wheel left
# Button 4: Scroll wheel right
# Button 5: G-Shift
# Button 6: G7
# Button 7: G8
# Button 8: G9
# Button 9: G10
# Button 10: G11
# Button 11: G12
# Button 12: G13
# Button 13: G14
# Button 14: G15
# Button 15: G16
# Button 16: G17
# Button 17: G18
# Button 18: G19
# Button 19: G20
# LED 0: Thumb keys backlight

# Possible key settings
# button 1: left click
# button 2: right click
# button 3: middle click
# button 4: scroll wheel left
# button 5: scroll wheel right

# special:
# doubleclick
# wheel-left
# wheel-right
# wheel-up
# wheel-down
# ratchet-mode-switch
# resolution-cycle-up
# resolution-cycle-down
# resolution-up
# resolution-down
# resolution-alternate
# resolution-default
# profile-cycle-up
# profile-cycle-down
# profile-up
# profile-down
# second-mode
# battery-level

# Get device name with `ratbagctl list`
DEVICE_NAME="Logitech Gaming Mouse G600"

# Check that ratbagctl is available
if ! command -v ratbagctl >/dev/null 2>&1; then
    echo "ratbagctl missing"
    exit 1
fi

# Profile 0
## Report rate
ratbagctl "$DEVICE_NAME" profile 0 rate set 1000

## Resolutions
### Set resolution alternatives to 400/1200/2000/3200
ratbagctl "$DEVICE_NAME" profile 0 resolution active set 0
ratbagctl "$DEVICE_NAME" profile 0 dpi set 400
ratbagctl "$DEVICE_NAME" profile 0 resolution active set 1
ratbagctl "$DEVICE_NAME" profile 0 dpi set 1200
ratbagctl "$DEVICE_NAME" profile 0 resolution active set 2
ratbagctl "$DEVICE_NAME" profile 0 dpi set 2000
ratbagctl "$DEVICE_NAME" profile 0 resolution active set 3
ratbagctl "$DEVICE_NAME" profile 0 dpi set 3200

### Set 2000dpi
ratbagctl "$DEVICE_NAME" profile 0 resolution active set 2
ratbagctl "$DEVICE_NAME" profile 0 resolution default set 2

## Buttons
ratbagctl "$DEVICE_NAME" profile 0 button 0 action set button 1 # left click
ratbagctl "$DEVICE_NAME" profile 0 button 1 action set button 2 # right lick
ratbagctl "$DEVICE_NAME" profile 0 button 2 action set button 3 # middle click
ratbagctl "$DEVICE_NAME" profile 0 button 3 action set button 4 # scroll wheel left
ratbagctl "$DEVICE_NAME" profile 0 button 4 action set button 5 # scroll wheel right
ratbagctl "$DEVICE_NAME" profile 0 button 5 action set macro KEY_F22
ratbagctl "$DEVICE_NAME" profile 0 button 6 action set macro KEY_F23
ratbagctl "$DEVICE_NAME" profile 0 button 7 action set macro KEY_F24
ratbagctl "$DEVICE_NAME" profile 0 button 8 action set macro KEY_KP1
ratbagctl "$DEVICE_NAME" profile 0 button 9 action set macro KEY_KP2
ratbagctl "$DEVICE_NAME" profile 0 button 10 action set macro KEY_KP3
ratbagctl "$DEVICE_NAME" profile 0 button 11 action set macro KEY_KP4
ratbagctl "$DEVICE_NAME" profile 0 button 12 action set macro KEY_KP5
ratbagctl "$DEVICE_NAME" profile 0 button 13 action set macro KEY_KP6
ratbagctl "$DEVICE_NAME" profile 0 button 14 action set macro KEY_KP7
ratbagctl "$DEVICE_NAME" profile 0 button 15 action set macro KEY_KP8
ratbagctl "$DEVICE_NAME" profile 0 button 16 action set macro KEY_KP9
ratbagctl "$DEVICE_NAME" profile 0 button 17 action set macro KEY_KP0
ratbagctl "$DEVICE_NAME" profile 0 button 18 action set macro KEY_KPPLUS
ratbagctl "$DEVICE_NAME" profile 0 button 19 action set macro KEY_KPMINUS

## LED colours
ratbagctl "$DEVICE_NAME" profile 0 led 0 set mode on
ratbagctl "$DEVICE_NAME" profile 0 led 0 set color 00ffff

# Profile 1
## Report rate
ratbagctl "$DEVICE_NAME" profile 1 rate set 1000

## Resolutions
### Set resolution alternatives to 400/1200/2000/3200
ratbagctl "$DEVICE_NAME" profile 1 resolution active set 0
ratbagctl "$DEVICE_NAME" profile 1 dpi set 400
ratbagctl "$DEVICE_NAME" profile 1 resolution active set 1
ratbagctl "$DEVICE_NAME" profile 1 dpi set 1200
ratbagctl "$DEVICE_NAME" profile 1 resolution active set 2
ratbagctl "$DEVICE_NAME" profile 1 dpi set 2000
ratbagctl "$DEVICE_NAME" profile 1 resolution active set 3
ratbagctl "$DEVICE_NAME" profile 1 dpi set 3200

### Set 2000dpi
ratbagctl "$DEVICE_NAME" profile 1 resolution active set 2
ratbagctl "$DEVICE_NAME" profile 1 resolution default set 2

## Buttons
ratbagctl "$DEVICE_NAME" profile 1 button 0 action set button 1 # left click
ratbagctl "$DEVICE_NAME" profile 1 button 1 action set button 2 # right lick
ratbagctl "$DEVICE_NAME" profile 1 button 2 action set button 3 # middle click
ratbagctl "$DEVICE_NAME" profile 1 button 3 action set button 4 # scroll wheel left
ratbagctl "$DEVICE_NAME" profile 1 button 4 action set button 5 # scroll wheel right
ratbagctl "$DEVICE_NAME" profile 1 button 5 action set macro KEY_F22
ratbagctl "$DEVICE_NAME" profile 1 button 6 action set macro KEY_F23
ratbagctl "$DEVICE_NAME" profile 1 button 7 action set macro KEY_F24
ratbagctl "$DEVICE_NAME" profile 1 button 8 action set macro +KEY_LEFTSHIFT KEY_F1 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 9 action set macro +KEY_LEFTSHIFT KEY_F2 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 10 action set macro +KEY_LEFTSHIFT KEY_F3 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 11 action set macro +KEY_LEFTSHIFT KEY_F4 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 12 action set macro +KEY_LEFTSHIFT KEY_F5 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 13 action set macro +KEY_LEFTSHIFT KEY_F6 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 14 action set macro +KEY_LEFTSHIFT KEY_F7 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 15 action set macro +KEY_LEFTSHIFT KEY_F8 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 16 action set macro +KEY_LEFTSHIFT KEY_F9 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 17 action set macro +KEY_LEFTSHIFT KEY_F10 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 18 action set macro +KEY_LEFTSHIFT KEY_F11 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 1 button 19 action set macro +KEY_LEFTSHIFT KEY_F12 -KEY_LEFTSHIFT

## LED colours
ratbagctl "$DEVICE_NAME" profile 1 led 0 set mode on
ratbagctl "$DEVICE_NAME" profile 1 led 0 set color ff00ff

# Profile 2
## Report rate
ratbagctl "$DEVICE_NAME" profile 2 rate set 1000

## Resolutions
### Set resolution alternatives to 400/1200/2000/3200
ratbagctl "$DEVICE_NAME" profile 2 resolution active set 0
ratbagctl "$DEVICE_NAME" profile 2 dpi set 400
ratbagctl "$DEVICE_NAME" profile 2 resolution active set 1
ratbagctl "$DEVICE_NAME" profile 2 dpi set 1200
ratbagctl "$DEVICE_NAME" profile 2 resolution active set 2
ratbagctl "$DEVICE_NAME" profile 2 dpi set 2000
ratbagctl "$DEVICE_NAME" profile 2 resolution active set 3
ratbagctl "$DEVICE_NAME" profile 2 dpi set 3200

### Set 2000dpi
ratbagctl "$DEVICE_NAME" profile 2 resolution active set 2
ratbagctl "$DEVICE_NAME" profile 2 resolution default set 2

## Buttons
ratbagctl "$DEVICE_NAME" profile 2 button 0 action set button 1 # left click
ratbagctl "$DEVICE_NAME" profile 2 button 1 action set button 2 # right lick
ratbagctl "$DEVICE_NAME" profile 2 button 2 action set button 3 # middle click
ratbagctl "$DEVICE_NAME" profile 2 button 3 action set button 4 # scroll wheel left
ratbagctl "$DEVICE_NAME" profile 2 button 4 action set button 5 # scroll wheel right
ratbagctl "$DEVICE_NAME" profile 2 button 5 action set macro KEY_F22
ratbagctl "$DEVICE_NAME" profile 2 button 6 action set macro KEY_F23
ratbagctl "$DEVICE_NAME" profile 2 button 7 action set macro KEY_F24
ratbagctl "$DEVICE_NAME" profile 2 button 8 action set macro +KEY_LEFTSHIFT KEY_F1 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 9 action set macro +KEY_LEFTSHIFT KEY_F2 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 10 action set macro +KEY_LEFTSHIFT KEY_F3 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 11 action set macro +KEY_LEFTSHIFT KEY_F4 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 12 action set macro +KEY_LEFTSHIFT KEY_F5 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 13 action set macro +KEY_LEFTSHIFT KEY_F6 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 14 action set macro +KEY_LEFTSHIFT KEY_F7 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 15 action set macro +KEY_LEFTSHIFT KEY_F8 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 16 action set macro +KEY_LEFTSHIFT KEY_F9 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 17 action set macro +KEY_LEFTSHIFT KEY_F10 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 18 action set macro +KEY_LEFTSHIFT KEY_F11 -KEY_LEFTSHIFT
ratbagctl "$DEVICE_NAME" profile 2 button 19 action set macro +KEY_LEFTSHIFT KEY_F12 -KEY_LEFTSHIFT

## LED colours
ratbagctl "$DEVICE_NAME" profile 2 led 0 set mode on
ratbagctl "$DEVICE_NAME" profile 2 led 0 set color ffff00

# Set unreachable buttons to `none`
for i in {0..2}; do
    ratbagctl "$DEVICE_NAME" profile $i button 20 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 21 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 22 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 23 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 24 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 25 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 26 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 27 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 28 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 29 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 30 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 31 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 32 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 33 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 34 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 35 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 36 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 37 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 38 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 39 action set disabled
    ratbagctl "$DEVICE_NAME" profile $i button 40 action set disabled
done