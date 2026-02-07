#!/usr/bin/env bash

# Front App Plugin with Catppuccin Mocha Theme
# Clean app name display with proper truncation

# Source color definitions
source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "front_app_switched" ]; then
  # Truncate long app names for better display
  APP_NAME="$INFO"
  if [ ${#APP_NAME} -gt 25 ]; then
    APP_NAME="${APP_NAME:0:25}…"
  fi
  
  sketchybar --set "$NAME" \
      label="$APP_NAME" \
      label.color="$TEXT"
fi
