#!/bin/bash

WALLPAPER_DIR="$HOME/Downloads"
find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.webp" \) | shuf -n 1