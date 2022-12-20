#!/bin/bash

sinks=( "alsa_output.usb-Jieli_Technology_UACDemoV1.0_4150333236393501-01.analog-stereo" "alsa_output.pci-0000_00_1f.3.analog-stereo" )

sink1="alsa_output.pci-0000_00_1f.3.analog-stereo"
sink2="alsa_output.usb-Jieli_Technology_UACDemoV1.0_4150333236393501-01.analog-stereo"

default_sink=$(pactl get-default-sink)

if [ "$default_sink" == "$sink1" ]; then
    sink_nick="Onboard"
fi
if [ "$default_sink" == "$sink2" ]; then
    sink_nick="External"
fi

short_sinks_json=$(pactl --format="json" list short sinks)

ignored_sinks=( "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra2" )
volume_raw=$(pactl get-sink-volume @DEFAULT_SINK@)
volume=$(echo $volume_raw | grep "Volume" | cut -d '/' -f 2 | grep -Po "\\d+")

case "$1" in
    --vol-up)
        if [ "$volume" -lt 100 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ +5%
        fi
        ;;
     --vol-down)
        if [ "$volume" -gt 0 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ -5%
        fi
        ;;
    --switch)
        sink_count=$(echo $short_sinks_json | jq -r '. | length')
        for ((i=0;i<$sink_count;i++)); 
        do  
            iter_sink=$(echo $short_sinks_json | jq -r ".[$i].name")
            if [ "$default_sink" == "$iter_sink" ]; then
                # $(printf '%s\0' "${ignored_sinks[@]}" | grep -Fxqz -- "$itersink")
                let next_sink_index="($i+1) % $sink_count"
                next_sink_name=$( echo $short_sinks_json | jq -r ".[$next_sink_index].name" )
                pactl set-default-sink $next_sink_name
            fi
        done
        ;;
    --toggle_mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    --get-volume)
        echo "$volume"
        ;;
    --gui)
        pavucontrol &
        ;;
    --mute_status)
        echo $(pactl get-sink-mute @DEFAULT_SINK@ | cut -d ' ' -f 2)
        ;;
    --set_vol)
        if [ "$2" -le 100 ] && [ "$2" -ge 0 ] ; then
            pactl set-sink-volume @DEFAULT_SINK@ "$2"%
        fi
        ;;
    --mic_status)
        amixer get Capture | grep '\[on\]' &>/dev/null
        if [ "$?" == 0 ]; then
            mic_status="on"
        else
            mic_status="off"
        fi
        echo -n $mic_status
        ;;
    --mic_toggle)
        amixer set Capture toggle &>/dev/null
        ;;
esac

# [
#   {
#     "index": 47,
#     "name": "alsa_output.usb-Jieli_Technology_UACDemoV1.0_4150333236393501-01.analog-stereo",
#     "driver": "PipeWire",
#     "sample_specification": "s16le 2ch 48000Hz",
#     "state": "IDLE"
#   },
#   {
#     "index": 48,
#     "name": "alsa_output.pci-0000_00_1f.3.analog-stereo",
#     "driver": "PipeWire",
#     "sample_specification": "s32le 2ch 48000Hz",
#     "state": "RUNNING"
#   },
#   {
#     "index": 357,
#     "name": "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra2",
#     "driver": "PipeWire",
#     "sample_specification": "s32le 2ch 48000Hz",
#     "state": "IDLE"
#   }
# ]

