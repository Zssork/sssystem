
_stowTheme(){
    # stow gtk (symlink .files)
    echo ":: create symlink for theme config"
    rm -rf ~/.config/gtk-3.0/settings.ini
    rm -rf ~/.config/hypr
    rm -rf ~/.config/wofi
    rm -rf ~/.config/kitty
    stow theme
}

_installTheme(){
    if gum confirm "ready to fuck the system?"; then
        _stowTheme
    fi

    # if [ ! -d "/usr/share/themes/Juno" ]; then
    #     echo ":: Installing Juno theme"
    #     sudo git clone https://github.com/EliverLara/Juno.git /usr/share/themes/Juno
    # else
    #     echo ":: Juno theme already installed"
    # fi

}