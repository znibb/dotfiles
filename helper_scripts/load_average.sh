#!/bin/bash

# Author:			znibb
# Contact:			znibb@zkylark.se
# Date created:		2018-10-21
# Last modified:	2024-07-04

# Echoes current system load averages, can toggle between default value and normalizing for core count 
# For use e.g. as a script component in polybar

INTERVAL=1	# Sleep duration, default if not supplied
NUMBER_OF_CPU_CORES=8

# Simple binary toggle
t=0

toggle() {
    t=$(((t + 1) % 2))
}

trap "toggle" USR1

while true; do
	# Get load average from uptime
	LOAD=$(uptime | grep -ohe 'load average[s:][: ].*')

	# Separate 1, 5 and 15 min values and replace decimal designator
	LOAD1=$(echo "$LOAD" | awk '{ print substr($3, 1, length($3)-1) }' | sed 's/,/./g')
	LOAD2=$(echo "$LOAD" | awk '{ print substr($4, 1, length($4)-1) }' | sed 's/,/./g')
	LOAD3=$(echo "$LOAD" | awk '{ print substr($5, 1, length($5)-1) }' | sed 's/,/./g')

	# If display mode has been toggled
	if [[ t -eq 1 ]]; then	
		# Scale values relative to number of CPU cores
		LOAD1=$(echo "$LOAD1/$NUMBER_OF_CPU_CORES" | bc -l)
		LOAD2=$(echo "$LOAD2/$NUMBER_OF_CPU_CORES" | bc -l)
		LOAD3=$(echo "$LOAD3/$NUMBER_OF_CPU_CORES" | bc -l)
	fi

	# Ensure consistent formatting
	LOAD1=$(echo "$LOAD1" | awk '{ printf "%0.2f", $1}')
	LOAD2=$(echo "$LOAD2" | awk '{ printf "%0.2f", $1}')
	LOAD3=$(echo "$LOAD3" | awk '{ printf "%0.2f", $1}')

	echo "$LOAD1 $LOAD2 $LOAD3"

	# Wait for next iteration
	if [[ $# -ge 1 ]]; then
		sleep $1
	else
		sleep $INTERVAL
	fi
done
