#!/bin/bash

# Author:			znibb
# Contact:			znibb@zkylark.se
# Date created:		2018-10-29
# Last modified:	2024-07-04

# Allows easy install of a list of apt packages from a text file

USAGE="Usage: $0 [-r] file1 file2 ... fileN"

if [[ "$(whoami)" != "root" ]]; then
	echo "Must run as root"
	exit 1
fi

if [[ ($# -lt 1) || ("$1" == "-r" && $# -lt 2) ]]; then
	echo "$USAGE"
	exit 2
fi

if [[ "$1" == "-r" ]]; then
	shift

	while (( "$#" )); do
		if [[ $(cat "$1") == "" ]]; then
			echo "Empty file: $1, skipping"
		else
			apt remove -y $(awk '{print $1}' $1)
			apt autoremove -y
		fi
		shift
	done
else
	while (( "$#" )); do
		if [[ $(cat "$1") == "" ]]; then
			echo "Empty file: $1, skipping"
		else
			apt install -y $(awk '{print $1}' $1)
		fi
		shift
	done
fi
exit 0
