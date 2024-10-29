#!/bin/bash

# Add mozilla ppa if not already present
[[ -f /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-noble.sources ]] || sudo add-apt-repository -y ppa:mozillateam/ppa > /dev/null 2>&1

# Set ppa priority higher than snap
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: thunderbird
Pin: version 2:1snap*
Pin-Priority: -1
' | sudo tee /etc/apt/preferences.d/thunderbird > /dev/null 2>&1

# Update
sudo apt update > /dev/null 2>&1

# Install
which thunderbird > /dev/null 2>&1 || sudo apt install -y thunderbird thunderbird-locale-sv
