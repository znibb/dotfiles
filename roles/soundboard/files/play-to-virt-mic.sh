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

if ! command -v mpv &>/dev/null; then
    echo "Error: mpv not found. Install it:"
    echo "  sudo pacman -S mpv"
    exit 1
fi

mpv --no-video --audio-device="pulse/${SINK_NAME}" -- "$FILE" >/dev/null
