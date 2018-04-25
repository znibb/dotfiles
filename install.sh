#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Error: no home path"
	exit 1
fi

home_path=$1
script_path=$(dirname $(realpath $0))

apt update
touch /tmp/apt_updated

selected_list=($(whiptail --title "Dotfiles installer" --separate-output --checklist \
"Choose modules to install" 20 78 4 \
"i3" "i3wm with i3blocks etc" OFF \
"vim" "vim config" OFF \
"alias" "Common aliases for bash" OFF \
"alias_rpi" "RPi-specific aliases" OFF \
3>&1 1>&2 2>&3))

for i in "${selected_list[@]}"
do
	case "$i" in
		"i3")
			$script_path/./setup_i3.sh $home_path
			;;
		"vim")
			$script_path/./setup_vim.sh $home_path
			;;
		*)
			echo "invalid: $i"
			;;
	esac
done




rm /tmp/apt_updated
exit 0
