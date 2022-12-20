#!/bin/bash

usage(){
    if [ ! "$(which udisksctl)" = "" ]; then
        return 0
    else
        # install udisks2
        # install libnotify-bin for norify-send notifications
        return 2
    fi
}

unset DRIVES
while IFS= read -r LINE; do
    DRIVES+=("${LINE}")
done < <( lsblk -r | grep /media | cut -d' ' -f 1)

count=$( echo -e "${#DRIVES[@]}\c" )

get_mounted_drive_count(){
    # if [[ "$count" -gt "0" ]]; then
	#     # echo -e "%{F$FOREGROUND_ALT}󱊟%{F-} %{T7}$count%{T-}\c"
    #     echo -n "$count"
    # fi
    echo -n "$count"
}

case "$1" in
    --list)
        usage && get_mounted_drive_info
        ;;
    --count)
        usage && get_mounted_drive_count
        ;;
esac

# drive_sep=""

# for drive in ${DRIVES[@]}; do
#     echo $drive
# done

# lsblk -r | grep /run | cut -d' ' -f 7,8 | cut -d'/' -f 4 )

# umount_power_off() {
#     echo "TODO"
# }

# get_mounted_drive_info(){
#     gen_sep
#     DRIVES_LAST=${DRIVES[-1]}
#     DRIVES_WITHOUT_LAST=${DRIVES[@]::${#DRIVES[@]}-1}
#     for drive in ${DRIVES_WITHOUT_LAST[@]}; do
#         name=$(lsblk -r | grep -F "$drive" | cut -d' ' -f 1)
#         udiskctl_command=$( 
#             echo "udisksctl unmount -b /dev/$name && notify-send \"mount_ctrl.sh\" \"unmounted $drive\" && sleep 3 && udisksctl power-off -b /dev/$name && notify-send \"mount_ctrl.sh\" \"powered-off $drive\"" 
#         )
#         echo -e "%{F$FOREGROUND_ALT}󱊟%{F-} %{T7}%{F$FOREGROUND}$drive%{F-}%{T-} %{A1:$udiskctl_command:}%{F$ALERT}󰤁%{F-}%{A} | \c"
#     done
#     echo -e "%{F$FOREGROUND_ALT}󱊟%{F-} %{T7}%{F$FOREGROUND}$DRIVES_LAST%{F-}%{T-} %{A1:$udiskctl_command:}%{F$ALERT}󰤁%{F-}%{A}\c"
#     printf "\n"
# }

# TODO: notify when not able to unmount
# TODO: lsblk -r | grep /media | awk -F' ' '{print NF}' --> returns where to cut
# button to open drive in file manager
# show encrypted partitions
