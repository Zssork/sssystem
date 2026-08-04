#!/bin/bash
# color_config_path="/home/$USER/.cache/wal/colors-hyprland.conf"
color_config_path="/home/$USER/.cache/wal/colors-hyprland.lua"
fallback_wallpaper="/home/$USER/.config/hypr/resources/ruan-jia.jpg"

if [ ! -e "$color_config_path" ];then
    wal -i "$fallback_wallpaper"
fi