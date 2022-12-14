#!/bin/bash

for i in /sys/class/power_supply/BAT*; do
  sysclass=$( echo "$(<$(dirname $i)): $(cat ${i%_*}_label 2>/dev/null || \
  echo $(basename ${i%_*})) $i" | \
  grep "BAT" | \
  awk -F' ' '{print $3}')
done

if [ ! -d "$sysclass" ]; then
	# echo "$(date) ${PWD}/`basename "$0"`: no $sysclass directory found"
	# TODO: PWD is different when executed by polybar
	echo "no /sys/class/power_supply/* directory found"
	exit 2
fi
