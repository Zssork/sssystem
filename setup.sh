#!/bin/bash

# Check if package is installed
_isInstalled() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0 #'0' means 'true' in Bash
        return #true
    fi
    echo 1 #'1' means 'false' in Bash
    return #false
}

# Check if command exists
_checkCommandExists() {
    package="$1"
    if ! command -v $package >/dev/null; then
        return 1
    else
        return 0
    fi
}

# Install required pacman packages
_installPackages() {
    toInstall=()
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi
        toInstall+=("${pkg}")
    done
    if [[ "${toInstall[@]}" == "" ]]; then
        # nothing to install 
        return
    fi
    printf "Package not installed: %s\n" "${toInstall[@]}"
    sudo pacman --noconfirm -S "${toInstall[@]}"
}

# Install required yay packages
_installYayPackages() {
    toInstall=()

    # Make sure yay is installed
    if _checkCommandExists "yay"; then
        echo ":: yay is already installed"
    else
        echo ":: The installer requires yay. yay will be installed now"
        _installYay
    fi

    # Install required yay packages
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi
        toInstall+=("${pkg}")
    done
    if [[ "${toInstall[@]}" == "" ]]; then
        # nothing to install 
        return
    fi
    printf "Yay package not installed: %s\n" "${toInstall[@]}"
    yay -S --noconfirm "${toInstall[@]}"
}


# install yay if needed
_installYay() {
    _installPackages "base-devel"
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")

    # Setup temp folder
    download_folder="$temp_path/yay_temp"
    if [ ! -d $download_folder ]; then
        mkdir -p $download_folder
    fi

    git clone https://aur.archlinux.org/yay.git $download_folder/yay
    cd $download_folder/yay
    makepkg -si
    cd $temp_path
    
    rm -rf $download_folder
    echo ":: yay has been installed successfully."
}


_installZsh() {
    # Change shell to zsh
    while ! chsh -s $(which zsh); do
        echo "ERROR: Authentication failed. Please enter the correct password."
        sleep 1
    done
    echo ":: Shell is now zsh."

    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # stow zsh (symlink .files)
    echo ":: create symlink for zsh config"
    rm -rf ~/.zshrc
    stow zsh


    # Installing zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo ":: Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
        echo ":: zsh-autosuggestions already installed"
    fi

    # Installing zsh-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        echo ":: Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo ":: zsh-syntax-highlighting already installed"
    fi

    # Installing fast-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting" ]; then
        echo ":: Installing fast-syntax-highlighting"
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    else
        echo ":: fast-syntax-highlighting already installed"
    fi

    echo ":: Select your font by calling: oh-my-posh font install "
    # im using Hack
}

_installTheme() {
    # setup wal with a default wallpaper
    wal -i ./theme/hypr/resources/ruan-jia.jpg

    # stow gtk (symlink .files)
    echo ":: create symlink for theme config"
    rm -rf ~/.config/gtk-3.0/settings.ini
    rm -rf ~/.config/hypr
    rm -rf ~/.config/wofi
    rm -rf ~/.config/kitty
    stow theme
}

##################################################################

# make all scripts executable
find ./ -type f -iname "*.sh" -exec chmod +x {} \;

# Package installation
mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "packages.lst")
_installPackages "${packages[@]}"

# AUR package installation
mapfile -t yay_packages < <(grep -vE '^\s*#|^\s*$' "packages-aur.lst")
_installYayPackages "${yay_packages[@]}"

# ZSH
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ":: Installing oh-my-zsh"

    if gum confirm "Install zsh?"; then
        _installZsh
    fi
else
    echo ":: oh-my-zsh already installed"
fi

# Theme
if [ ! -d "$HOME/.config/hypr/scripts" ]; then # check kinda shit right now
    echo ":: Installing theme"
    
    if gum confirm "Ready to fuck the SSSystem?"; then
        _installTheme
    fi
else
    echo ":: theme already installed"
fi

echo "done yeah!"
