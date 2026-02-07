#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Get memory usage
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
        printf "%.0f", usage_percent
    } else {
        printf "0"
    }
}'
)

# Ensure memory_info is not empty
if [[ -z "$memory_info" ]]; then
    memory_info="0"
fi

# Determine RAM color based on usage
if [[ $memory_info -gt 80 ]]; then
    ram_color="$RED"
elif [[ $memory_info -gt 60 ]]; then
    ram_color="$YELLOW"
else
    ram_color="$GREEN"
fi

# Update the item
sketchybar --set ram \
    icon="􀫦" \
    label="${memory_info}%" \
    icon.color="$ram_color" \
    label.color="$TEXT"