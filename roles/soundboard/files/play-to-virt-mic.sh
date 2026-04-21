#!/usr/bin/env bash
set -euo pipefail

SINK_NAME="virt_mic"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <audio-file>"
    exit 1
fi

FILE="$1"

if [[ ! -f "$FILE" ]]; then
    echo "Error: file not found: $FILE"
    exit 1
fi

if ! pactl list sinks short | grep -q "$SINK_NAME"; then
    echo "Error: virtual sink '$SINK_NAME' not found. Run setup-virt-mic.sh first."
    exit 1
fi

if command -v mpv &>/dev/null; then
    mpv --no-video --audio-device="pulse/${SINK_NAME}" -- "$FILE" >/dev/null
elif command -v ffplay &>/dev/null; then
    ffplay -nodisp -autoexit \
        -af "aresample=async=1" \
        "$FILE" >/dev/null &
    FFPLAY_PID=$!
    # Move the stream to the virtual sink once it appears
    sleep 0.5
    SINK_INPUT=$(pactl list sink-inputs short | awk '{print $1}' | tail -1)
    if [[ -n "$SINK_INPUT" ]]; then
        pactl move-sink-input "$SINK_INPUT" "$SINK_NAME"
    fi
    wait "$FFPLAY_PID"
else
    echo "Error: neither mpv nor ffplay found. Install one:"
    echo "  sudo pacman -S mpv"
    echo "  sudo pacman -S ffmpeg"
    exit 1
fi
