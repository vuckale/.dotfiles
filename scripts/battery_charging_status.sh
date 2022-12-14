#!/bin/bash

source "$(dirname "$0")/common.sh"

state=$(cat $sysclass/status)
state=$(echo "$state" | awk '{print tolower($0)}')
state="battery ${state}"
