#!/bin/bash
if [ ! "$( which rfkill )" = "" ]; then
    status=$( rfkill list wifi )
    if [ ! -z "$status" ]; then
        if [ $( echo "$status" | grep "Soft blocked: yes" | wc -l ) -gt 0 ] ; then
            rfkill unblock wifi
            dunstify -a "$0" -u low -h string:x-dunst-stack-tag:wifi-switch.sh "WLAN" "Enabled Wireless, connecting to previously used ssid..."
        else
            SSID=$( iwgetid -r )
            rfkill block wifi
            if [ "$SSID" = "" ]; then
                msg="Disabled Wireless"
            else
                msg="Disabled Wireless, disconnected from ${SSID}"
            fi
            dunstify -a "$0" -u low -h string:x-dunst-stack-tag:wifi-switch.sh "WLAN" "$msg"
        fi
    else
        # no wifi
        echo "Y"
    fi
else
    # no rfkill
    echo "X"
fi
