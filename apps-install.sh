#!/bin/bash
source "common.sh"

# Install optional flatpak apps
_installFlathubPackages() {
    toInstall=()
    for pkg; do
        # check if already installed
        if flatpak list --app | awk '{print $2}' | grep -q "^$pkg$"; then
            echo ":: ${pkg} is already installed."
            continue
        fi
        toInstall+=("${pkg}")
    done
    
    if [[ "${toInstall[@]}" == "" ]]; then
        # nothing to install 
        return
    fi

    if gum confirm "Install flatpak apps?"; then
        for pkg in "${toInstall[@]}"; do
            flatpak install flathub -y "${pkg}"
        done
    fi
}

# Apps installation
mapfile -t apps < <(grep -vE '^\s*#|^\s*$' "apps.lst")
_installPackages "${apps[@]}"

# Yay app installation
mapfile -t yay_apps < <(grep -vE '^\s*#|^\s*$' "apps-aur.lst")
_installYayPackages "${yay_apps[@]}"

# Flatpak app installation
mapfile -t flathub_apps < <(grep -vE '^\s*#|^\s*$' "apps-flathub.lst")
_installFlatpakPackages "${flathub_apps[@]}"


# install Steam with multilib
# https://wiki.archlinux.org/title/Steam

# install Blender + cuda
# https://wiki.archlinux.org/title/Blender

# install DaVinci
# yay -S davinci-resolve

# PyCharm
# flatpak install flathub com.jetbrains.PyCharm-Community

# Vs code
# I recommend setting the font to 'JetBrainsMonoNL Nerd Font Mono'

# Wine (native windows apps)
# flatpak install bottles