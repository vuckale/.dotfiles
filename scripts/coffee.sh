#!/bin/sh
# 󰅶

# ps cax | grep "lock-inactive" > /dev/null
# if [ $? -eq 0 ]; then
#   echo "%{A1:killall -9 lock-inactive.sh 2> /dev/null:}%{F$FOREGROUND}󰅶%{F-}%{A}"
# else
#   echo "%{A1:/home/aleksandar/.dotfiles/i3/.config/i3/scripts/lock-inactive.sh &:}%{F$ALERT}󰅶%{F-}%{A}"
# fi

# https://wiki.archlinux.org/title/Display_Power_Management_Signaling
timeout=600
function xset_off() {
    sleep 1; xset s 0 0; sleep 1; xset dpms 0 0 0
}

function xset_on() {
    sleep 1; xset s $timeout $timeout; sleep 1; xset dpms $timeout $timeout $timeout
}

case "$1" in
    --on)
        xset_off
        ;;
    --off)
        xset_on
        ;;
esac
