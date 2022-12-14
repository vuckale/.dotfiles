#!/bin/bash

device="Wireless Mouse MX Master"
device_short="MX Master"
path=$(upower -d | grep -B 2 "$device" | grep "Device" | cut -d' ' -f2 2> /dev/null) # /org/freedesktop/UPower/devices/mouse_hidpp_battery_0
native_path=$(upower -i $path | grep "native-path" | xargs  echo | cut -d' ' -f 2) # hidpp_battery_0

charging_status=$(upower -i $path | grep "state" | xargs  echo | cut -d' ' -f 2)
battery=$(upower -i "$path" | grep "percentage" | head -1 | grep -o '[[:digit:]]*')

icon_flag=0
raw_flag=0
case "$1" in
    --icon)
		icon_flag=1
		;;
	--raw)
        raw_flag=1
		;;
esac

if [ "$charging_status" = "unknown" ]; then
    if [ "$icon_flag" == 1 ]; then
        echo "󰍾"
    fi
    if [ "$raw_flag" == 1 ]; then
        echo "$device offline"
    fi
else
    if [ "$charging_status" = "charging" ]; then
        if [ "$icon_flag" == 1 ]; then
            echo "󰂄 󰦋"
        fi
        if [ "$raw_flag" == 1 ]; then
            echo "$device charging"
        fi
    else
        if [ "$icon_flag" == 1 ]; then
            if [ "$battery" = 100 ];then
                echo "󰦋 󱊣"
            elif [[ "$battery" -lt 100 ]] && [[ "$battery" -ge 50 ]]; then
                echo "󰦋 󱊢"
            elif [[ "$battery" -lt 50 ]] && [[ "$battery" -ge 10 ]]; then
                echo "󰦋 󱊡"
            elif [[ "$battery" -lt 10 ]]; then
                echo "󰦋 󱃍"
            fi
        fi
        if [ "$raw_flag" == 1 ]; then
            echo "${battery}%"
        fi
        
    fi
fi

# TODO error handling
# TODO bluetooth vs dongle
