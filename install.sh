#!/bin/bash

###############
### Install ###
###############

# Copy Files to Home Directory
echo
echo "-----------------------------------------------------------------------"
echo "------------------- Copying files to Home directory -------------------"
echo "-----------------------------------------------------------------------"

cp -v bash/.* ~/

mkdir -p ~/.config/nvim
cp -rv vim/* ~/.config/nvim

mkdir -p ~/.local/bin/myscripts
cp -rv scripts/* ~/.local/bin/myscripts

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
