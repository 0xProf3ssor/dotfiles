#!/usr/bin/env bash

# Volume Plugin with Catppuccin Mocha Theme
# Clean colorless icons with red indication for muted state

# Source color definitions
source "$CONFIG_DIR/colors.sh"

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100) ICON="󰕾"
    ;;
    [3-5][0-9]) ICON="󰖀"
    ;;
    [1-9]|[1-2][0-9]) ICON="󰕿"
    ;;
    *) ICON="󰖁"
  esac

  # Use perfect Catppuccin colors based on volume level
  if [ "$VOLUME" = "0" ]; then
    # Muted: Use red color for both icon and text
    ICON_COLOR="$RED"
    LABEL_COLOR="$RED"
  else
    # Normal: Use sapphire blue for icon (matches your theme), white for text
    ICON_COLOR="$SAPPHIRE"
    LABEL_COLOR="$TEXT"
  fi

  sketchybar --set "$NAME" \
      icon="$ICON" \
      icon.color="$ICON_COLOR" \
      label="$VOLUME%" \
      label.color="$LABEL_COLOR"
fi
