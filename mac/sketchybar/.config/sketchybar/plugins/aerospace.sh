#!/usr/bin/env bash

# AeroSpace Workspace Plugin with Catppuccin Mocha Theme
# Clean text-only workspace indicators - no backgrounds or borders

# Source color definitions
source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    # Active workspace: bright mauve text with bold font
    sketchybar --set $NAME \
        label.color="$MAUVE" \
        label.font="Hack Nerd Font:Bold:13.0"
else
    # Inactive workspace: dimmed text with medium font
    sketchybar --set $NAME \
        label.color="$SUBTEXT1" \
        label.font="Hack Nerd Font:Medium:12.0"
fi
