#!/bin/bash

status1=$(amixer | awk '/Front Left: Capture/ {print $7}')
status2=$(amixer | awk '/Front Right: Capture/ {print $7}')

if [ "${status1}" == "[on]" ] && [ "${status2}" == "[on]" ]; then
	echo "Mic: On"
else
	echo "Mic: Off"
fi

exit 0
