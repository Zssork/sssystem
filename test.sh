self=$0
echo $self

if flatpak list --app | awk '{print $2}' | grep -q "^$package$"; then
    echo "joar"
fi

# WALLPAPER_DIR="$HOME/Downloads"
# #WALLPAPERS=$(find "$WALLPAPER_DIR" -type f)


# WALLPAPERS=()
# while IFS= read -r -d '' file; do
#     echo "found: $file"
#     WALLPAPERS+=("$file")
# done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0)

# echo "$WALLPAPER_DIR"


# mapfile -d '' shuffled_wallpapers < <(printf '%s\0' "${WALLPAPERS[@]}" | shuf --zero-terminated)

# for wallpaper in "${shuffled_wallpapers[@]}"; do
#     echo "entry: \"$wallpaper\""
# done

# script_name="test.sh"

# CURRENT_PID=$$

# kill_other_instances(){
#     mapfile -t OTHERS < <(pgrep -f "$script_name" | grep -v "^$CURRENT_PID$")
    
#     if [ ${#OTHERS[@]} -eq 0 ]; then
#         echo "No other instances of $script_name found."
#         return
#     fi
    
#     for pid in "${OTHERS[@]}"; do
#         echo "Trying to kill $pid: $(ps -p "$pid" -o args=)"
#         kill -9 "$pid"
#     done
# }

# kill_other_instances

# # while true; do
# #     sleep 1
# #     echo "moin"
# # done &