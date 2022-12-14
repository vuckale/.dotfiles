#!/bin/bash

if [ ! "$( which rfkill )" = "" ]; then
	status=$( rfkill list | grep -A2 Bluetooth )
	if [ ! -z "$status" ]; then
		status_soft=$( rfkill -r | grep bluetooth | cut -d ' ' -f 4 )
		status=unset
		if [ $status_soft == "blocked" ]; then
			status="bluetooth off"
		elif [ $status_soft == "unblocked" ]; then
			status="bluetooth on"
		fi
	else
		echo "no bluetooth interface found"
		exit 2
	fi
else
	echo "rfkill not installed"
	exit 2
fi
