#!/bin/bash

# 󰘚 󰈐

gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
gpu_fan=$(nvidia-smi --query-gpu=fan.speed --format=csv,noheader | grep -Po "\\d+")
