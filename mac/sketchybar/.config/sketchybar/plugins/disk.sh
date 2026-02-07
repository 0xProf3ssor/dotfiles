#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Get disk usage for root filesystem (/) - use -h for human readable
disk_info=$(df -h / | tail -1)

# Extract used percentage (remove % symbol) - this is the 5th column
used_percent=$(echo "$disk_info" | awk '{print $5}' | sed 's/%//')

# Extract available space - this is the 4th column
available_space=$(echo "$disk_info" | awk '{print $4}')

# Extract used and total space for verification
used_space=$(echo "$disk_info" | awk '{print $3}')
total_space=$(echo "$disk_info" | awk '{print $2}')

# Debug: Let's see what we're getting
# echo "Debug: Used=$used_space, Available=$available_space, Total=$total_space, Percent=$used_percent"

# Determine color based on usage level
if [[ $used_percent -ge 90 ]]; then
    # Critical - red
    color="$RED"
    icon="􀨪"  # externaldrive.fill
elif [[ $used_percent -ge 80 ]]; then
    # Warning - yellow/orange  
    color="$PEACH"
    icon="􀨪"  # externaldrive.fill
elif [[ $used_percent -ge 70 ]]; then
    # Caution - yellow
    color="$YELLOW"  
    icon="􀨪"  # externaldrive.fill
else
    # Good - green
    color="$GREEN"
    icon="􀨪"  # externaldrive.fill
fi

# Format display - show percentage and available space (without 'free' text)
display_text="${used_percent}% | ${available_space}"

# Update the sketchybar item
sketchybar --set disk \
    icon="$icon" \
    label="$display_text" \
    icon.color="$color" \
    label.color="$TEXT"