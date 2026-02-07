#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Get CPU usage percentage - fix parsing
cpu_percent=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//' | cut -d'.' -f1)
if [[ -z "$cpu_percent" || "$cpu_percent" == "" ]]; then
    cpu_percent="0"
fi

# Get memory usage - fix calculation
memory_info=$(vm_stat | awk '
BEGIN { 
    page_size = 4096
}
/Pages free:/ { 
    gsub(/[^0-9]/, "", $3)
    free = $3 
}
/Pages active:/ { 
    gsub(/[^0-9]/, "", $3)
    active = $3 
}
/Pages inactive:/ { 
    gsub(/[^0-9]/, "", $3)
    inactive = $3 
}
/Pages speculative:/ { 
    gsub(/[^0-9]/, "", $3)
    spec = $3 
}
/Pages wired down:/ { 
    gsub(/[^0-9]/, "", $4)
    wired = $4 
}
END {
    if (free == "") free = 0
    if (active == "") active = 0
    if (inactive == "") inactive = 0
    if (spec == "") spec = 0
    if (wired == "") wired = 0
    
    free_pages = free + spec
    used_pages = active + inactive + wired
    total_pages = free_pages + used_pages
    
    if (total_pages > 0) {
        usage_percent = (used_pages / total_pages) * 100
        printf "%.0f%%", usage_percent
    } else {
        printf "0%%"
    }
}'
)

# Ensure memory_info is not empty
if [[ -z "$memory_info" ]]; then
    memory_info="0%"
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

# Format display: CPU% | RAM%
display_text="${cpu_percent}% | ${memory_info}"

# Update the item
sketchybar --set system \
    icon="􀫥" \
    label="$display_text" \
    icon.color="$cpu_color" \
    label.color="$TEXT"