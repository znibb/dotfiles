#!/bin/bash

# If no path was given as argument use current users home dir as target
if [[ "$#" -ne 1 ]]; then
	target_path=$(echo $HOME)
else
	target_path=$1
fi

# Get path this script was run from
script_path=$(dirname $(realpath $0))

# Prompt for confirmation if not running as batched script
if [[ ! -f /tmp/running_batch ]]; then
	read -p "Install i3 with '$target_path' as base target dir? [Y/n]" answer
	case $answer in
		[Nn]* ) exit 1;;
	esac
	apt update
fi

# Install packages
apt install -y \
	i3 \
	vim \
	pulseaudio-utils \
	feh \
	scrot \
	imagemagick
	font-awesome

# Install playerctl
dpkg -i "$script_path/tools/playerctl-0.5.0_amd64.deb"

## Copy/link files
# Fonts
mkdir -p $target_path/.fonts
cp $script_path/fonts/* $target_path/.fonts/
# i3 config
mkdir -p $target_path/.config/i3
ln $script_path/i3/config 				$target_path/.config/i3/
ln $script_path/i3/lock_clean.sh	$target_path/.config/i3/
ln -s $target_path/.config/i3/lock_clean.sh $target_path/.config/i3/lock.sh
# User scripts
mkdir -p $target_path/scripts
ln $script_path/user_scripts/* $target_path/scripts/
# Helper scripts
mkdir -p $target_path/.scripts
ln $scripts_path/helper_scripts/* $target_path/.scripts
# Wallpapers
mkdir -p $target_path/wallpapers
cp $script_path/wallpapers/* $target_path/wallpapers
ln -s $target_path/wallpapers/misty_hills.jpg $target_path/.config/wallpaper.image
