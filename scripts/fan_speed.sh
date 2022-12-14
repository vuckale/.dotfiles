#!/bin/bash

# setup sensors and find out which fan is your cpu fan
cpu_fan="fan2"

if [ ! "$( which sensors )" = "" ]; then
    # left_fan=$( sensors | grep "Left" | cut -d':' -f2 | cut -d ' ' -f2 )
    # right_fan=$( sensors | grep "Right" | cut -d':' -f2 | cut -d ' ' -f2 )
    cpu_fan_speed=$(sensors -u | grep -i "${cpu_fan}_input" | cut -d ':' -f 2 | awk '{$1=$1};1' | cut -d'.' -f 1)
    cpu_fan_speed="${cpu_fan_speed} rpm"
else
    echo "it seems like you haven't setup \"lm sensors\" or you haven't run \"sensors-detect\""""
    exit 1
fi

# case "$1" in
#     --polybar)
#         # echo "%{F$FOREGROUND_ALT}󰈐%{F-} %{F$FOREGROUND_ALT}󰫹%{F-}$left_fan%{F$FOREGROUND_ALT}󰫿%{F-}$right_fan"
#         echo "%{F$FOREGROUND_ALT}󰫹%{F-}$left_fan%{F$FOREGROUND_ALT}󰫿%{F-}$right_fan"
#         ;;
#     --raw)
#         echo "left: $left_fan RPM right: $right_fan RPM"
#         ;;
# esac
