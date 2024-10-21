#!/bin/bash

exe_name=signal-desktop

if ! which $exe_name > /dev/null; then
  # Get signing key
  sudo wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg

    # Add repository to list
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-xenial.list

    # Update database
    sudo apt update

    # Install
    sudo apt install -y signal-desktop
fi
