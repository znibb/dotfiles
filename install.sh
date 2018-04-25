#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Error: no home path"
	exit 1
fi

home_path=$1
script_path=$(dirname $(realpath $0))

apt update
touch /tmp/apt_updated

$script_path/./setup_i3.sh $home_path
$script_path/./setup_vim.sh $home_path

rm /tmp/apt_updated
exit 0
