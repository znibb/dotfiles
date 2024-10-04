#!/bin/bash

# Add mozilla ppa if not already present
[[ -f /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-noble.sources ]] || sudo add-apt-repository -y ppa:mozillateam/ppa > /dev/null 2>&1

# Set ppa priority higher than snap
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 900
' | sudo tee /etc/apt/preferences.d/mozilla > /dev/null 2>&1

# Update
sudo apt update > /dev/null 2>&1

# Install
which firefox > /dev/null 2>&1 || sudo apt install -y firefox
