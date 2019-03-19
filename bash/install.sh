#!/bin/bash

###################
## Check Prereqs ##
###################

require() {
	command -v "$1" >/dev/null 2>&1 || { echo >&2 "I require "$1" but it's not installed.  Aborting."; exit 1; }
}

require "npm"
require "yarn"
require "nvim"

require "tmux"
require "watch"

require "python3"
require "cmake"

###################
### Pre Install ###
###################

# Clean Home Directory
echo
echo "-----------------------------------------------------------------------"
echo "----------------------- Cleaning Home directory -----------------------"
echo "-----------------------------------------------------------------------"
rm -rfv \
  ~/.vim \
  ~/.vimrc \
  ~/.config \
  ~/.aliasrc \
  ~/.bashrc \
  ~/.inputrc \
  ~/.profile \
  ~/.fzf \
  ~/.bash_profile
clear

###############
### Install ###
###############

# Copy Files to Home Directory
echo
echo "-----------------------------------------------------------------------"
echo "------------------- Copying files to Home directory -------------------"
echo "-----------------------------------------------------------------------"
cp -v lib/.* ~/

mkdir -p ~/.config
cp -rv lib/.config/ ~/.config
clear

####################
### Post Install ###
####################

# Change to Home Directory
cd ~/

# Link vim files to nvim (done to support both vim and neovim)
echo
echo "-----------------------------------------------------------------------"
echo "-------------------------- Linking vim files --------------------------"
echo "-----------------------------------------------------------------------"
ln -sv ~/.config/nvim .vim
ln -sv ~/.config/nvim/init.vim .vimrc
clear

# Link .bash_profile to .profile
echo
echo "-----------------------------------------------------------------------"
echo "------------------------ Linking bash_profile -------------------------"
echo "-----------------------------------------------------------------------"
ln -sv ~/.profile ~/.bash_profile
source ~/.bash_profile
clear

# Install Vim-Plug
echo
echo "-----------------------------------------------------------------------"
echo "------------------------- Installing vim-plug -------------------------"
echo "-----------------------------------------------------------------------"
yes | curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
clear

# Install fzf
echo
echo "-----------------------------------------------------------------------"
echo "--------------------------- Installing fzf ----------------------------"
echo "-----------------------------------------------------------------------"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install
clear

# Instructions to finish
echo
echo "-----------------------------------------------------------------------"
echo "-------------------------- Install finished! --------------------------"
echo "-----------------------------------------------------------------------"
echo "    1: Launch vim"
echo "    2: Run :PlugInstall"
echo "    3: Quit vim"
echo ""
