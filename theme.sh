
_installTheme(){
    # stow gtk (symlink .files)
    echo ":: create symlink for theme config"
    rm -rf ~/.config/gtk-3.0/settings.ini
    stow theme


    if [ ! -d "/usr/share/themes/Juno" ]; then
        echo ":: Installing Juno theme"
        sudo git clone https://github.com/EliverLara/Juno.git /usr/share/themes/Juno
    else
        echo ":: Juno theme already installed"
    fi

    if [ ! -d "/usr/share/themes/Andromeda" ]; then
        echo ":: Installing Andromeda theme"
        sudo git clone https://github.com/EliverLara/Andromeda-gtk.git /usr/share/themes/Andromeda
    else
        echo ":: Andromeda theme already installed"
    fi

}