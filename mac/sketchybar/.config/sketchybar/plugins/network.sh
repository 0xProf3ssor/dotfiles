#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Get WiFi information
wifi_info=$(networksetup -getairportnetwork en0 2>/dev/null)

if [[ "$wifi_info" == *"Wi-Fi power is currently off"* ]]; then
    # WiFi is off
    icon="􀙈"  # wifi.slash
    network_text="WiFi Off"
    color="$SUBTEXT0"
elif [[ "$wifi_info" == *"You are not associated with an AirPort network"* ]]; then
    # WiFi on but not connected
    icon="􀙈"  # wifi.slash  
    network_text="No WiFi"
    color="$YELLOW"
else
    # WiFi connected - extract network name
    network_name=$(echo "$wifi_info" | sed 's/Current Wi-Fi Network: //')
    
    # Get signal strength (requires admin privileges, fallback gracefully)
    signal_strength=$(iwconfig en0 2>/dev/null | grep -o 'Signal level.*' || echo "")
    
    # Determine WiFi icon based on connection
    icon="􀙇"  # wifi
    
    # Clean up network name if too long
    if [[ ${#network_name} -gt 12 ]]; then
        network_text="${network_name:0:9}..."
    else
        network_text="$network_name"
    fi
    
    color="$GREEN"
fi

# Check if VPN is active (common VPN indicators)
vpn_status=""
vpn_active=false

# Check for common VPN interfaces
if ifconfig | grep -q "utun\|tun\|tap" 2>/dev/null; then
    # Check if any VPN-like interface has an IP
    for interface in $(ifconfig | grep "^utun\|^tun\|^tap" | cut -d: -f1); do
        if ifconfig "$interface" 2>/dev/null | grep -q "inet "; then
            vpn_active=true
            break
        fi
    done
fi

# Check for WireGuard
if command -v wg >/dev/null 2>&1; then
    if wg show 2>/dev/null | grep -q "interface:"; then
        vpn_active=true
    fi
fi

# Add VPN indicator if active
if [[ "$vpn_active" == true ]]; then
    vpn_status=" 🛡️"
fi

# Combine display text
display_text="${network_text}${vpn_status}"

# Update the sketchybar item
sketchybar --set network \
    icon="$icon" \
    label="$display_text" \
    icon.color="$color" \
    label.color="$TEXT"