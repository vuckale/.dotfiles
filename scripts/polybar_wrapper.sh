#!/bin/bash

# args=( "$@" )

# case "$1" in
#     --battery_charging_status)
#         # (([ "$2" = "--icon" ] && echo "󱐥") || ([ "$2" = "--text" ] && echo "$state"))
#         # echo ${args[@]} # print array
#         # echo $# # argument count
#         # echo ${args[$#-1]} # last element in array
#         source "battery_charging_status.sh"
#         state="charging"
# 		[ $state = "full" ] && ([ "$2" = "--icon" ] && echo -n "󱐥")
#         [ $state = "discharging" ] && ([ "$2" = "--icon" ] && echo -n "%{F$ALERT}󱐤%{F-}")
#         [ $state = "charging" ] && ([ "$2" = "--icon" ] && echo -n "󱐥󱐋")
#         [ ${args[$#-1]} = "--text" ] && (([ "$2" = "--icon" ] && echo -n " $state") || echo -n "$state")
# 	    ;;
#     --disk_space)
#         source "disk_space.sh"
#         [ ${args[$#-1]} = "--icon" ] && echo "󰋊 %{F$FOREGROUND}${used}/${size}%{F-}"
#         [ ${args[$#-1]} = "--text" ] && echo -n "${used}/${size}"
#         ;;
# esac

# https://www.shellscript.sh/tips/getopt/index.html
ICON=unset
TEXT=unset
SCRIPT=1
HOME=$(eval echo ~${SUDO_USER})
DOTFILES="${HOME}/.dotfiles/scripts"
usage()
{
  echo "Usage: alphabet [ -a | --alpha ] [ -b | --beta ]
                        [ -c | --charlie CHARLIE ] 
                        [ -d | --delta   DELTA   ] filename(s)"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n $0 -o s:it --long script:,icon,text -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

# echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -i | --icon)   ICON=1      ; shift   ;;
    -t | --text)    TEXT=1       ; shift   ;;
    -s | --script) SCRIPT="$2" ; shift 2 ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

if [ "$SCRIPT" != "1" ]; then
    msg=""
    checksum=$(( $ICON + $TEXT ))
    if [ "$checksum" != "0" ]; then
        case "$SCRIPT" in
            --battery_charging_status)
                source "$(dirname "$0")/battery_charging_status.sh"
                [ "$ICON" == 1 ] && \
                (\
                ([ "$state" = "battery full" ] && echo -n "󱐥") || \
                ([ "$state" = "battery discharging" ] && echo -n "%{F$ALERT}󱐤%{F-}") || \
                ([ "$state" = "battery charging" ] && echo -n "󱐥󱐋")\
                )
                [ $TEXT == 1 ] &&  ([ "$checksum" == 1 ] && echo -n "$state" || echo -n " $state")
                ;;
            --disk_space)
                source "$(dirname "$0")/disk_space.sh"
                [ "$ICON" == 1 ] && echo -n "󰋊 "
                [ "$TEXT" == 1 ] &&  ([ "$checksum" == 1 ] && echo -n "${used}/${size}" || echo -n " ${used}/${size}")
                ;;
            --bluetooth_status)
                source "$(dirname "$0")/bluetooth_status.sh"
                command="%{A2:$DOTFILES/bluetooth_switch.sh:}"
                command_status="${command}$status%{A}"
                [ $ICON == 1 ] && \
                (\
                ([ "$status_soft" = "blocked" ] && echo -n "${command}󰂲%{A}") || \
                ([ "$status_soft" = "unblocked" ] && echo -n echo "${command}󰂯%{A}")
                )
                [ "$TEXT" == 1 ] && ([ "$checksum" == 1 ] && echo -n "$command_status" || echo -n " $command_status")
                ;;
            --fan_speed)
                source "$(dirname "$0")/fan_speed.sh"
                [ $ICON == 1 ] && echo -n "󰈐 "
                [ "$TEXT" == 1 ] && ([ "$checksum" == 1 ] && echo -n "$cpu_fan_speed" || echo -n " $cpu_fan_speed")
                ;;           
            --mx_master)
                source "$(dirname "$0")/mx_master.sh"
                [ "$ICON" == 1 ] && \
                (\
                ([ "$charging_status" = "unknown" ] && echo -n "%{F$FOREGROUND_ALT}󰍾%{F-}") || \
                ([ "$charging_status" = "charging" ] && echo -n "%{F$FOREGROUND_ALT}󰂄 󰦋%{F-}") || \
                ([ "$charging_status" = "discharging" ] && \
                    (\
                    ([ "$battery" == 100 ] && echo -n "%{F$FOREGROUND_ALT}󰦋%{F-} 󱊣") || \
                    ([[ "$battery" -lt 100 ]] && [[ "$battery" -gt 50 ]] && echo -n "%{F$FOREGROUND_ALT}󰦋%{F-} 󱊢") || \
                    ([[ "$battery" -lt 50 ]] && [[ "$battery" -ge 10 ]] && echo -n "%{F$FOREGROUND_ALT}󰦋%{F-} 󱊡") || \
                    ([ "$battery" -lt 10 ] && echo -n "%{F$FOREGROUND_ALT}󰦋%{F-} 󱃍")\
                    )\
                )\
                )
                [ $TEXT == 1 ] &&  \
                ([ "$charging_status" = "unknown" ] && \
                    ([ "$checksum" == 1 ] && echo -n "$device_short offline" || echo -n " $device_short offline")) || \
                ([ "$checksum" == 1 ] && echo -n "$device_short $charging_status $battery%" || echo -n " $device_short $charging_status $battery%")
                ;;
            --lsblk_info)
                output=$($(dirname "$0")/lsblk_info.sh --count)
                #source "$(dirname "$0")/mount_ctrl.sh"
                #count=0
                if [ "$output" = "0" ]; then
                    sep=$( echo -e "" )
                else
                    sep=$( echo -e " | " )
                fi
                [ $ICON == 1 ] && echo -n "%{A1:gnome-disks:}󰋊$sep%{A} "
                [ $TEXT == 1 ] &&  ([ "$checksum" == 1 ] && echo -n "$output" || echo -n " $output")
                ;;
            --public_ip)
                output=$($(dirname "$0")/public_ip.sh)
                [ $ICON == 1 ] && echo -n "󰣩"
                [ $TEXT == 1 ] &&  ([ "$checksum" == 1 ] && echo -n "$output" || echo -n " $output")
                ;;
            --xset_q)
                source "$(dirname "$0")/xset_q.sh"
                if [[ "$CAPS_LOCK_STATUS" == "on" ]]; then
                    CAPS_LOCK_STATUS_ICON="%{F$ALERT}󰘲%{F-}"
                    CAPS_LOCK_STATUS_TEXT="Caps Lock On"
                else
                    CAPS_LOCK_STATUS_ICON=""
                    CAPS_LOCK_STATUS_TEXT=""
                fi
                if [[ "$NUM_LOCK_STATUS" == "on" ]]; then
                    NUM_LOCK_STATUS_ICON="%{F$ALERT}󰎠%{F-}"
                    NUM_LOCK_STATUS_TEXT="Num Lock On"
                else
                    NUM_LOCK_STATUS_ICON=""
                    NUM_LOCK_STATUS_TEXT=""
                fi

                [ $ICON == 1 ] && echo -n "$CAPS_LOCK_STATUS_ICON"
                [ $TEXT == 1 ] &&  ([ "$checksum" == 1 ] && echo -n "$CAPS_LOCK_STATUS_TEXT" || echo -n " $CAPS_LOCK_STATUS_TEXT")
                [ $ICON == 1 ] && echo -n " $NUM_LOCK_STATUS_ICON"
                [ $TEXT == 1 ] &&  ([ "$checksum" == 1 ] && echo -n " $NUM_LOCK_STATUS_TEXT" || echo -n " $NUM_LOCK_STATUS_TEXT")
                ;;
            *)
                usage
                ;;
        esac
    else
    echo "1"
        usage
    fi
else
echo "2"
    usage
fi
