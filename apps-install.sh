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


    if gum confirm "Setup flatpak themes?"; then
        # sadly flatpak wont allow access to /usr/share/ so we need to copy the shit here
        mkdir $HOME/.themes
        mkdir $HOME/.icons
        cp -r /usr/share/themes/Materia-dark-compact $HOME/.themes/Materia-dark-compact
        cp -r /usr/share/themes/Materia-dark $HOME/.themes/Materia-dark
        cp -r /usr/share/icons/breeze-dark $HOME/.icons/breeze-dark

        # Use GTK and QT themes
        sudo flatpak override --filesystem=$HOME/.themes
        sudo flatpak override --filesystem=$HOME/.icons
        sudo flatpak override --env=GTK_THEME=Materia-dark
        sudo flatpak override --env=ICON_THEME=breeze-dark

        sudo flatpak override --env=QT_STYLE_OVERRIDE=kvantum 
        sudo flatpak override --filesystem=xdg-config/Kvantum:ro
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

## DaVinci
# yay -S davinci-resolve

## PyCharm
# flatpak install flathub com.jetbrains.PyCharm-Community

## Vs code
# I recommend setting the font to 'JetBrainsMonoNL Nerd Font Mono'

## Wine (native windows apps)
# flatpak install bottles