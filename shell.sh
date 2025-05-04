
_installZsh(){
    # Change shell to shh
    while ! chsh -s $(which zsh); do
        echo "ERROR: Authentication failed. Please enter the correct password."
        sleep 1
    done
    echo ":: Shell is now zsh."

    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


    ## Fix when font is wrong:
    # oh-my-posh font install
    # select Hack

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
}