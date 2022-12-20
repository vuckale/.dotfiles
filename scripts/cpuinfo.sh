#!/bin/bash

readarray -d '' "freqs" < \
    <( cat /proc/cpuinfo | grep MHz | cut -d ':' -f 2 )

cpus=$(lscpu | grep "^CPU(s):" | grep -Po "\\d+")



sum=0
for freq in ${freqs[@]}; do
    int=${freq%.*}
    let sum+=$int
done

MHz=$(echo $sum/$cpus | bc -l)
GHz=$(echo $MHz/1000 | bc -l)

cpu_freq_ghz=$(printf "%.2f GHz" $GHz)
cpu_temp=$(echo -n $(sensors | grep "Package id 0:" | cut -d ':' -f 2 | cut -d'(' -f 1))
cpu_usage=$(echo -n "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"")

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
