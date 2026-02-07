#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Cache file to avoid too many API calls
CACHE_FILE="/tmp/sketchybar_weather"
CACHE_DURATION=1800  # 30 minutes

# Function to get weather data
get_weather() {
    # Use wttr.in for simple weather data (no API key needed)
    # Format: temperature and condition icon
    weather_data=$(curl -s "wttr.in?format=%t+%C" 2>/dev/null | tr -d '\n')
    
    if [[ -n "$weather_data" && "$weather_data" != *"Unknown"* ]]; then
        echo "$weather_data"
    else
        echo "Weather N/A"
    fi
}

# Check if cache exists and is recent
if [[ -f "$CACHE_FILE" ]]; then
    cache_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)))
    if [[ $cache_age -lt $CACHE_DURATION ]]; then
        weather_info=$(cat "$CACHE_FILE")
    else
        weather_info=$(get_weather)
        echo "$weather_info" > "$CACHE_FILE"
    fi
else
    weather_info=$(get_weather)
    echo "$weather_info" > "$CACHE_FILE"
fi

# Parse temperature to determine color
temp=$(echo "$weather_info" | grep -o '[+-]\?[0-9]\+°[CF]' | head -n1)
if [[ -n "$temp" ]]; then
    # Extract numeric value
    temp_num=$(echo "$temp" | grep -o '[+-]\?[0-9]\+')
    
    # Determine color based on temperature (assuming Celsius, adjust if needed)
    if [[ $temp_num -le 0 ]]; then
        temp_color="$BLUE"
        icon="❄️"
    elif [[ $temp_num -le 15 ]]; then
        temp_color="$SAPPHIRE"
        icon="🌤️"
    elif [[ $temp_num -le 25 ]]; then
        temp_color="$GREEN"
        icon="☀️"
    else
        temp_color="$RED"
        icon="🔥"
    fi
else
    temp_color="$SUBTEXT1"
    icon="🌡️"
fi

# Clean up the weather info for display
display_info=$(echo "$weather_info" | sed 's/+//g' | head -c 20)

# Update the item
sketchybar --set weather \
    icon="$icon" \
    label="$display_info" \
    icon.color="$temp_color" \
    label.color="$TEXT"