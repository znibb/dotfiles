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
	font-awesome \
	# Required for polybar
	libmpdclient2 \
	libxcb-ewmh2

# Install playerctl
dpkg -i "$script_path/tools/playerctl-0.5.0_amd64.deb"

## Copy/link files
# Fonts
mkdir -p $target_path/.fonts
cp -r $script_path/fonts/ $target_path/.fonts/
# i3 config
mkdir -p $target_path/.config/i3
ln -f $script_path/i3/config 				$target_path/.config/i3/
ln -f $script_path/i3/lock_clean.sh	$target_path/.config/i3/
ln -sf $target_path/.config/i3/lock_clean.sh $target_path/.config/i3/lock.sh
# polybar
cp $script_path/tools/polybar /usr/local/bin/polybar
mkdir -p $target_path/.config/polybar
cp -flr $script_path/polybar/. $target_path/.config/polybar/
# User scripts
mkdir -p $target_path/scripts
cp -flr $script_path/user_scripts/. $target_path/scripts/
# Helper scripts
mkdir -p $target_path/.scripts
cp -flr $script_path/helper_scripts/. $target_path/.scripts/
# Wallpapers
mkdir -p $target_path/wallpapers
cp -r $script_path/wallpapers/* $target_path/wallpapers/
ln -sf $target_path/wallpapers/misty_hills.jpg $target_path/.config/wallpaper.image
# Bash config
cp -flr $script_path/bash/.	$target_path/
rm $target_path/.profile
# X resouces
cp -flr $script_path/X/.		$target_path/
# vim config
cp -flr $script_path/vim/.	$target_path/
