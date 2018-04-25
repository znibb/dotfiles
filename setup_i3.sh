#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Error: no home path"
	exit 1
fi

home_path=$1
script_path=$(dirname $(realpath $0))	# Get path script was run from

# If batching "apt update" has already been run
if [ ! -f /tmp/apt_updated ]; then
	apt update
fi

# Install packages
apt install -y 	i3 \ 			# Duh
		vim \ 			# Also duh
		pulseaudio-utils \ 	# For media controls
		feh \ 			# Displaying wallpapers
		arandr \ 		# Helps with multi-monitor setup
		lxappearance \ 		# Handle themes
		arc-theme \ 		# Nice gtk theme
		moka-icon-theme		# Icon theme pack
		rofi \			# Dmenu replacement
		comption \		# Allows for opaque windows
		i3blocks \		# Better option for status bar than i3status
		scrot \			# Screen capture tool for generating blurred lock screen
		imagemagick		# For blurring lock screen

# Install playerctl
dpkg -i "$script_path/tools/playerctl-0.5.0_amd64.deb"	# For media control

## Copy files
mkdir -p $home_path/.fonts
cp $script_path/fonts/* $home_path/.fonts/
mkdir -p $home_path/.config/i3
cp $script_path/i3/i3.conf $home_path/.config/i3/config
cp $script_path/i3/i3blocks.conf $home_path/.config/i3.i3blocks.conf
mkdir -p $home_path/scripts/i3blocks
cp $script_path/i3/i3blocks_scripts/* $home_path/scripts/i3blocks/
cp $script_path/scripts/i3lock.sh $home_path/scripts/i3lock.sh
cp $script_path/scripts/toggleTouchpad.sh $home_path/scripts/toggleTouchPad.sh
cp $script_path/i3/.gtkrc-2.0 $home_path/
mkdir -p $home_path/.config/gtk-3.0
cp $script_path/i3/gtk-3.0_settings.ini $home_path/.config/gtk-3.0/settings.ini
mkdir -p $home_path/wallpapers
cp $script_path/wallpapers/* $home_path/wallpapers/


#sudo add-apt-repository ppa:moka/daily
#sudo apt-get update
#sudo apt-get install moka-icon-theme
