#!/bin/bash

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

# Flatpak package installation
mapfile -t yay_packages < <(grep -vE '^\s*#|^\s*$' "flatpak-apps.lst")
_installFlatpakPackages "${yay_packages[@]}"