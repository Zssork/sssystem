#!/bin/bash

# Paths:
ohmyposh_config="$HOME/.config/ohmyposh/craver.omp.json"
colors_file="$HOME/.cache/wal/colors"

# Input:
relative_image=$1
image=$(realpath $relative_image)

echo "relative: $relative_image"
echo "absolute: $image"

if ! test -f "$image"; then
    echo "Bruh ... there is no such file!"
    exit 1
fi

hyprctl hyprpaper reload ,"$image"
wal -i "$image"
hyprctl reload

swaync-client -rs

# Update sddm image
sudo rm /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/desktop.png
sudo cp "$image" /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/desktop.png

# Update ohmyposh
path_background=$(sed -n '5p' "$colors_file")
sed -i "0,/.*"path_background".*/{s/.*\"path_background\".*/    \"path_background\": \"$path_background\",/}" "$ohmyposh_config"