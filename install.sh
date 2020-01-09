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
  ~/.doc_templates \
  ~/.aliasrc \
  ~/.bashrc \
  ~/.inputrc \
  ~/.profile \
  ~/.fzf \
  ~/.bash_profile

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

mkdir -p ~/.doc_templates
cp -rv lib/.doc_templates/ ~/.doc_templates

mkdir -p ~/.scripts
cp -rv lib/.scripts/ ~/.scripts


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

# Link .bash_profile to .profile
echo
echo "-----------------------------------------------------------------------"
echo "------------------------ Linking bash_profile -------------------------"
echo "-----------------------------------------------------------------------"
ln -sv ~/.profile ~/.bash_profile
source ~/.bash_profile

# Instructions to finish
echo
echo "-----------------------------------------------------------------------"
echo "-------------------------- Install finished! --------------------------"
echo "-----------------------------------------------------------------------"
echo "    1: Launch vim"
echo "    2: Profit!"
echo ""
