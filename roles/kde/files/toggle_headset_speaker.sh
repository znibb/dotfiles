#!/bin/bash

# Config storage files
HEADSET_FILE="$HOME/.scripts/AUDIO_SINK_HEADSET.txt"
SPEAKER_FILE="$HOME/.scripts/AUDIO_SINK_SPEAKER.txt"

# Check if HEADSET sink has been set up
if [[ ! -f $HEADSET_FILE ]]; then
    # Assemble formatted string for radiolist
    options=()
    while read -r id name rest; do
        options+=("$name" "$name" "off")
    done < <(pactl list short sinks)

    # Display selection dialogue
    choice=$(kdialog --radiolist "Select HEADSET sink" "${options[@]}")

    # Store selected sink name to file
    echo $choice > $HEADSET_FILE
fi

# Check if SPEAKER sink has been set up
if [[ ! -f $SPEAKER_FILE ]]; then
    # Assemble formatted string for radiolist
    options=()
    while read -r id name rest; do
        options+=("$name" "$name" "off")
    done < <(pactl list short sinks)

    # Display selection dialogue
    choice=$(kdialog --radiolist "Select SPEAKER sink" "${options[@]}")

    # Store selected sink name to file
    echo $choice > $SPEAKER_FILE
fi

# Load sink names from respective file
HEADSET=$(< $HEADSET_FILE)
SPEAKER=$(< $SPEAKER_FILE)

# Get current default audio sink
CURRENT_DEVICE=$(pactl info | grep "Default Sink" | awk '{print $3}')

# Determine next audio sink
if [[ "$CURRENT_DEVICE" == "$HEADSET" ]]; then
    NEXT_DEVICE=$SPEAKER
else
    NEXT_DEVICE=$HEADSET
fi

# Set new default device
pactl set-default-sink $NEXT_DEVICE