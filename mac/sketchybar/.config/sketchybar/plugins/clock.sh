#!/usr/bin/env bash

# Clock Plugin with Catppuccin Mocha Theme
# Beautiful clock display with blue accent and calendar icon

# Source color definitions
source "$CONFIG_DIR/colors.sh"

# Get current date and time with better formatting
DATETIME=$(date '+%a %d/%m  %H:%M')

# Update the clock with Catppuccin theming and calendar icon
sketchybar --set "$NAME" \
    icon="􀧞" \
    label="$DATETIME" \
    label.color="$TEXT" \
    icon.color="$BLUE"

