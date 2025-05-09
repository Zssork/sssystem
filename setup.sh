#!/bin/bash
source "common.sh"

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

echo ":: Done yeah!"
