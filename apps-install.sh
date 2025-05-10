#!/bin/bash
source "common.sh"

# Install optional flatpak apps
_installFlatpakPackages() {
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

# Flatpak app installation
mapfile -t flatpak_apps < <(grep -vE '^\s*#|^\s*$' "apps-flatpak.lst")
_installFlatpakPackages "${flatpak_apps[@]}"

# Yay app installation
mapfile -t yay_packages < <(grep -vE '^\s*#|^\s*$' "apps-aur.lst")
_installYayPackages "${yay_packages[@]}"


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