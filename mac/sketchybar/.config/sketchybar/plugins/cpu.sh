#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Get CPU usage percentage - fix parsing
cpu_percent=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//' | cut -d'.' -f1)
if [[ -z "$cpu_percent" || "$cpu_percent" == "" ]]; then
    cpu_percent="0"
fi

# Determine CPU color based on usage
cpu_num=$(echo "$cpu_percent" | sed 's/%//')
if [[ $cpu_num -gt 80 ]]; then
    cpu_color="$RED"
elif [[ $cpu_num -gt 60 ]]; then
    cpu_color="$YELLOW"
else
    cpu_color="$GREEN"
fi

# Update the item
sketchybar --set cpu \
    icon="􀫥" \
    label="${cpu_percent}%" \
    icon.color="$cpu_color" \
    label.color="$TEXT"