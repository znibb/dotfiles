#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Error: no home path"
	exit 1
fi

home_path=$1
script_path=$(dirname $(realpath $0))

# If batching "apt update" has already been run
if [ ! -f /tmp/apt_updated ]; then
	apt update
fi
apt install -y vim

cp $script_path/vim/.vimrc $home_path/
