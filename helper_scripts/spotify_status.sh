#!/bin/bash

# Author:			znibb
# Contact:			znibb@zkylark.se
# Date created:		2018-10-21
# Last modified:	2018-10-21

# Echoes current information about Spotify playback
# For use e.g. as a script component in polybar

INTERVAL=1			# Sleep duration, default if not supplied
TRUNC_LENGTH=40	# Max output length (unicode character counts as 6) 

while true; do
	# If Spotify is running, otherwise return empty string
	if pgrep -x "spotify" > /dev/null; then
		# Determine if Spotify is currently playing and set icon accordingly
		if [[ $(playerctl -p spotify status) == 'Playing' ]]; then
			PLAY_PAUSE='\u25B6'	# Play sign
		else
			PLAY_PAUSE='\u25FC'	# Stop sign
		fi

		# Extract metadata
		ARTIST=`playerctl -p spotify metadata 'xesam:artist'`
		TITLE=`playerctl -p spotify metadata 'xesam:title'`

		# Assemble return string and truncate if needed
		OUTPUT="$PLAY_PAUSE $ARTIST - $TITLE"
		if [[ ${#OUTPUT} -gt $TRUNC_LENGTH ]]; then
			OUTPUT=$(echo $OUTPUT | cut -c 1-$TRUNC_LENGTH)
			OUTPUT="$OUTPUT..."
		fi

		echo -e "$OUTPUT"
	else
		echo ""
	fi

	# Wait for next iteration
	if [[ $# -ge 1 ]]; then
		sleep $1
	else
		sleep $INTERVAL
	fi
done
