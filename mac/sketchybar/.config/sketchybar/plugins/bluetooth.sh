#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Check if Bluetooth is enabled
bluetooth_status=$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null || echo "0")

if [[ "$bluetooth_status" == "1" ]]; then
    # Bluetooth is on
    icon="􀛪"  # bluetooth
    
    # Get connected devices count
    connected_devices=$(system_profiler SPBluetoothDataType 2>/dev/null | grep -c "Connected: Yes" || echo "0")
    
    if [[ "$connected_devices" -gt 0 ]]; then
        # Has connected devices
        if [[ "$connected_devices" -eq 1 ]]; then
            bluetooth_text="1 device"
        else
            bluetooth_text="$connected_devices devices"
        fi
        color="$BLUE"
    else
        # Bluetooth on but no devices connected
        bluetooth_text="On"
        color="$SUBTEXT1"
    fi
else
    # Bluetooth is off
    icon="􀛪"  # bluetooth (will be grayed out by color)
    bluetooth_text="Off"
    color="$SUBTEXT0"
fi

# Update the sketchybar item
sketchybar --set bluetooth \
    icon="$icon" \
    label="$bluetooth_text" \
    icon.color="$color" \
    label.color="$TEXT"