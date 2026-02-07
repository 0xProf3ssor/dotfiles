#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Get the current working directory from the front app (if it's a terminal/editor)
current_app=$(aerospace list-windows --focused --format "%{app-name}")

# Function to get git info from a directory
get_git_info() {
    local dir="$1"
    
    if [[ ! -d "$dir/.git" ]]; then
        # Check if we're in a subdirectory of a git repo
        local git_dir
        git_dir=$(cd "$dir" 2>/dev/null && git rev-parse --git-dir 2>/dev/null)
        if [[ -z "$git_dir" ]]; then
            return 1
        fi
        cd "$dir" 2>/dev/null || return 1
    else
        cd "$dir" || return 1
    fi
    
    # Get branch name
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    if [[ -z "$branch" ]]; then
        branch=$(git describe --contains --all HEAD 2>/dev/null || echo "detached")
    fi
    
    # Get git status info
    local status_output
    status_output=$(git status --porcelain 2>/dev/null)
    
    local staged=0
    local modified=0
    local untracked=0
    
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            case "${line:0:1}" in
                "A"|"M"|"D"|"R"|"C") ((staged++)) ;;
            esac
            case "${line:1:1}" in
                "M"|"D") ((modified++)) ;;
                "?") ((untracked++)) ;;
            esac
        fi
    done <<< "$status_output"
    
    # Determine status color and icon
    local icon="􀆃"  # git branch icon
    local status_color="$GREEN"
    local status_text=""
    
    if [[ $staged -gt 0 || $modified -gt 0 || $untracked -gt 0 ]]; then
        if [[ $staged -gt 0 ]]; then
            status_color="$YELLOW"
            status_text+=" +$staged"
        fi
        if [[ $modified -gt 0 ]]; then
            status_color="$PEACH"
            status_text+=" ~$modified"
        fi
        if [[ $untracked -gt 0 ]]; then
            status_color="$RED"
            status_text+=" ?$untracked"
        fi
    fi
    
    # Check if ahead/behind remote
    local ahead_behind
    ahead_behind=$(git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null || echo "0	0")
    local behind ahead
    behind=$(echo "$ahead_behind" | cut -f1)
    ahead=$(echo "$ahead_behind" | cut -f2)
    
    if [[ $ahead -gt 0 ]]; then
        status_text+=" ↑$ahead"
    fi
    if [[ $behind -gt 0 ]]; then
        status_text+=" ↓$behind"
    fi
    
    echo "$icon $branch$status_text|$status_color"
}

# Try to get git info from common directories
git_info=""

# Check if current app might have a working directory we can check
case "$current_app" in
    "Alacritty"|"Terminal"|"iTerm2"|"Warp")
        # For terminal apps, try the home directory and common project directories
        for dir in "$HOME" "$HOME/dotfiles" "$HOME/Projects" "$HOME/Code" "$HOME/Development"; do
            if [[ -d "$dir" ]]; then
                git_result=$(get_git_info "$dir")
                if [[ $? -eq 0 && -n "$git_result" ]]; then
                    git_info="$git_result"
                    break
                fi
            fi
        done
        ;;
    "Neovim"|"Visual Studio Code"|"Sublime Text"|"Atom")
        # For editors, try current directory and common locations
        git_result=$(get_git_info "$PWD")
        if [[ $? -eq 0 && -n "$git_result" ]]; then
            git_info="$git_result"
        fi
        ;;
esac

# If no git info found, check the dotfiles directory as fallback
if [[ -z "$git_info" ]]; then
    git_result=$(get_git_info "$HOME/dotfiles")
    if [[ $? -eq 0 && -n "$git_result" ]]; then
        git_info="$git_result"
    fi
fi

# Update the sketchybar item
if [[ -n "$git_info" ]]; then
    IFS='|' read -r display_text color_name <<< "$git_info"
    
    # Truncate branch name if too long
    if [[ ${#display_text} -gt 25 ]]; then
        display_text="${display_text:0:22}..."
    fi
    
    sketchybar --set git \
        label="$display_text" \
        icon.color="$color_name" \
        label.color="$TEXT" \
        drawing=on
else
    sketchybar --set git drawing=off
fi