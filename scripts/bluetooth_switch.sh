#!/bin/bash
if [ ! "$(which rfkill)" = "" ]; then
    status=$( rfkill list bluetooth )
	if [ ! -z "$status" ]; then
        if [ $( echo "$status" | grep "Soft blocked: yes" | wc -l ) -gt 0 ] ; then
            rfkill unblock bluetooth
            dunstify -h string:x-dunst-stack-tag:$0 "bluetooth On"
        else
            rfkill block bluetooth
            dunstify -h string:x-dunst-stack-tag:$0 "bluetooth Off"
        fi
    else
		dunstify -u critical -t 10000 string:x-dunst-stack-tag:$0 "bluetooth Interface not found"
	fi
else
    dunstify -u critical -t 10000 string:x-dunst-stack-tag:$0 "rfkill not installed"
fi
