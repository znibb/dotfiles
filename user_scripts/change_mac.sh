#!/bin/bash
# Dependancies:	ip link
#		macchanger
#		ping

timeout=10	# seconds
connectivity_target=8.8.8.8

# Check that we're running as sudo
if [[ $EUID -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi

# Bring interface down
ip link set dev wlp2s0 down
# Change to a random MAC
macchanger -r wlp2s0
# Bring interface up
ip link set dev wlp2s0 up
# Restart NetworkManager
service NetworkManager restart

# Check that connectivity is up
startTime=$(date +%s)

while true; do
	ping -c 1 $connectivity_target > /dev/null 2>&1
	if [[ $? -eq 0 ]]; then
		echo "Done"
		exit 0
	elif [[ "$(date +%s)" -ge  "($startTime + $timeout)" ]]; then
		echo "Timeout"
		exit 2
	fi	
done
