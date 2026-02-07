#!/usr/bin/env bash

# Catppuccin Mocha Color Palette for SketchyBar
# https://github.com/catppuccin/catppuccin

# Base Colors
export BASE="0xff1e1e2e"        # #1e1e2e - Main background
export MANTLE="0xff181825"      # #181825 - Darker background
export CRUST="0xff11111b"       # #11111b - Darkest background

# Surface Colors (for UI elements)
export SURFACE0="0xff313244"    # #313244 - Light surface
export SURFACE1="0xff45475a"    # #45475a - Medium surface
export SURFACE2="0xff585b70"    # #585b70 - Dark surface

# Overlay Colors (for borders and subtle elements)
export OVERLAY0="0xff6c7086"    # #6c7086 - Light overlay
export OVERLAY1="0xff7f849c"    # #7f849c - Medium overlay
export OVERLAY2="0xff9399b2"    # #9399b2 - Dark overlay

# Text Colors
export TEXT="0xffcdd6f4"        # #cdd6f4 - Primary text
export SUBTEXT1="0xffbac2de"   # #bac2de - Secondary text
export SUBTEXT0="0xffa6adc8"   # #a6adc8 - Tertiary text

# Accent Colors
export ROSEWATER="0xfff5e0dc"  # #f5e0dc
export FLAMINGO="0xfff2cdcd"   # #f2cdcd
export PINK="0xfff5c2e7"       # #f5c2e7
export MAUVE="0xffcba6f7"      # #cba6f7 - For workspaces
export RED="0xfff38ba8"        # #f38ba8 - For errors/low battery
export MAROON="0xffeba0ac"     # #eba0ac
export PEACH="0xfffab387"      # #fab387 - For volume
export YELLOW="0xfff9e2af"     # #f9e2af
export GREEN="0xffa6e3a1"      # #a6e3a1 - For good battery/success
export TEAL="0xff94e2d5"       # #94e2d5
export SKY="0xff89dceb"        # #89dceb
export SAPPHIRE="0xff74c7ec"   # #74c7ec
export BLUE="0xff89b4fa"       # #89b4fa - For clock
export LAVENDER="0xffb4befe"   # #b4befe

# Transparent variants (for backgrounds with opacity)
export BASE_TRANSPARENT="0xcc1e1e2e"        # Base with transparency
export SURFACE0_TRANSPARENT="0xcc313244"    # Surface0 with transparency
export MAUVE_TRANSPARENT="0xcccba6f7"       # Mauve with transparency

# Helper function to convert hex to SketchyBar format
hex_to_sketchybar() {
  echo "0xff${1#\#}"
}