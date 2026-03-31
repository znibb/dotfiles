#!/usr/bin/env bash

# Usage info
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 [-d] [file.tmux ...]"
    echo "  -d  Use all *.tmux files in ~/.config/tmux/"
    exit 1
fi

# Build file list
if [[ "$1" == "-d" ]]; then
    tmux_files=(~/.config/tmux/*.tmux)
else
    tmux_files=("$@")
fi

# Iterate over file(s)
for tmux_file in "${tmux_files[@]}"; do
    # Unset env vars to prevent past processing bleeding over
    unset SESSION BASE WINDOWS

    # Source session parameters
    source "$tmux_file"

    # Strip potential trailing / in BASE path
    BASE="${BASE%/}"

    # If session doesn't already exist
    if ! tmux has-session -t "$SESSION" 2>/dev/null; then
        # Create named session and initial named window
        first="${WINDOWS[0]}"
        tmux new-session -d -s "$SESSION" -n "${first%%:*}" -c "$BASE/${first##*:}"

        # Create the rest of the windows
        for entry in "${WINDOWS[@]:1}"; do
            tmux new-window -t "$SESSION" -n "${entry%%:*}" -c "$BASE/${entry##*:}"
        done

        # Focus first window pending future attachment to the session
        tmux select-window -t "$SESSION:${WINDOWS[0]%%:*}"
    fi
done
