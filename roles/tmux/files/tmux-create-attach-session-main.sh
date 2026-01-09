#!/bin/sh

# Session name
SESSION="main"

# Check if session already exists
SESSION_EXISTS=$(tmux list-sessions | grep $SESSION)

# If session doesn't exist
if [ -z "$SESSION_EXISTS" ]; then
    # Start session with name
    tmux new-session -d -s $SESSION

    # Window 1
    tmux rename-window -t 1 'df'
    tmux send-keys -t 'df' 'cd ~/.dotfiles' C-m 'clear' C-m

    # Window 2
    tmux new-window -t $SESSION:2
    tmux send-keys -t $SESSION:2 'cd' C-m 'clear' C-m
fi

# Check for being outside of tmux and vscode
if [ -z "$TMUX" ] &&[ "$TERM_PROGRAM" != "vscode" ]; then
    # Attach session on window 2
    tmux attach-session -t $SESSION:2
fi
