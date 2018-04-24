#!/bin/bash

# Check if running as root/sudo

#add-apt-repository ppa:moka/daily # Icon pack
apt update
apt install -y 	i3 \ 			# Duh
		vim \ 			# Also duh
		pulseaudio-utils \ 	# For media controls
		feh \ 			# Displaying wallpapers
		arandr \ 		# Helps with multi-monitor setup
		lxappearance \ 		# Handle themes
		arc-theme \ 		# Nice gtk theme
		moka-icon-theme		# Icon theme pack
		rofi			# Dmenu replacement
cp i3.conf /home/gene/.config/i3/config
cp .gtkrc-2.0 $HOME_DIR
cp settings.ini $HOME_DIR/.config/gtk-3.0


sudo add-apt-repository ppa:moka/daily
sudo apt-get update
sudo apt-get install moka-icon-theme
