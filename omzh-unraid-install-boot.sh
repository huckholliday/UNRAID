#!/bin/bash

# This script is used to install oh-my-zsh on Unraid boot

HOME=/root
OH_MY_ZSH_ROOT="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
OH_MY_ZSH_PLUGINS="$ZSH_CUSTOM/plugins"
OH_MY_ZSH_THEMES="$ZSH_CUSTOM/themes"
cd $HOME

if [ -d "$OH_MY_ZSH_ROOT" ]; then
        echo "$OH_MY_ZSH_ROOT already exists"
        exit 1
fi

# At the time of execution, the soft route had not yet started and there was no network
sleep 300

cp -sf .bash_profile .bashrc

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir -p $OH_MY_ZSH_PLUGINS
mkdir -p $OH_MY_ZSH_THEMES

# Install zsh-autosuggestions
if [ ! -d "$OH_MY_ZSH_PLUGINS/zsh-autosuggestions" ]; then
        echo "  -> Installing zsh-autosuggestions..."
        git clone https://ghproxy.com/https://github.com/zsh-users/zsh-autosuggestions $OH_MY_ZSH_PLUGINS/zsh-autosuggestions
else
        echo "  -> zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$OH_MY_ZSH_PLUGINS/zsh-syntax-highlighting" ]; then
        echo "  -> Installing zsh-syntax-highlighting..."
        git clone https://ghproxy.com/https://github.com/zsh-users/zsh-syntax-highlighting.git $OH_MY_ZSH_PLUGINS/zsh-syntax-highlighting
else
        echo "  -> zsh-syntax-highlighting already installed"
fi

chmod 755 $OH_MY_ZSH_PLUGINS/zsh-autosuggestions
chmod 755 $OH_MY_ZSH_PLUGINS/zsh-syntax-highlighting

chsh -s /bin/zsh

SOURCE_CONFIG=/boot/config/extra
# Make sure the necessary directories are existing
mkdir -p $SOURCE_CONFIG

# Make sure the .zsh_history file exists
touch "$SOURCE_CONFIG/.zsh_history"

# Symlink the .zshrc file and the .zsh_history file
cp -sf "$SOURCE_CONFIG/.zshrc" "$HOME/.zshrc"
cp -sf "$SOURCE_CONFIG/.zsh_history" "$HOME/.zsh_history"

sleep 5

# Set the theme to jonathan
omz theme set jonathan 

exit 0