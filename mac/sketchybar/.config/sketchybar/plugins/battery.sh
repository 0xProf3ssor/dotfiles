#!/usr/bin/env bash

# Battery Plugin with Catppuccin Mocha Theme
# Dynamic colors based on battery level and charging status

# Source color definitions
source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Determine battery icon based on level using SF Symbols
case "${PERCENTAGE}" in
  9[0-9]|100) ICON="􀛨"  # battery.100
  ;;
  [6-8][0-9]) ICON="􀺸"  # battery.75
  ;;
  [3-5][0-9]) ICON="􀺶"  # battery.50
  ;;
  [1-2][0-9]) ICON="􀛩"  # battery.25
  ;;
  *) ICON="􀛪"  # battery.0
esac

# Override icon if charging
if [[ "$CHARGING" != "" ]]; then
  ICON="􀢋"  # battery.100.bolt
fi

# Dynamic color based on battery level and charging status
if [[ "$CHARGING" != "" ]]; then
  # Charging: Use blue color
  ICON_COLOR="$BLUE"
  LABEL_COLOR="$TEXT"
elif [ "$PERCENTAGE" -le 20 ]; then
  # Low battery: Use red color
  ICON_COLOR="$RED"
  LABEL_COLOR="$RED"
elif [ "$PERCENTAGE" -le 40 ]; then
  # Medium battery: Use yellow color
  ICON_COLOR="$YELLOW"
  LABEL_COLOR="$TEXT"
else
  # Good battery: Use green color
  ICON_COLOR="$GREEN"
  LABEL_COLOR="$TEXT"
fi

# Update the battery item with dynamic theming
sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$ICON_COLOR" \
    label="${PERCENTAGE}%" \
    label.color="$LABEL_COLOR"
