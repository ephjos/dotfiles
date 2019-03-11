#!/bin/bash

###################
### Pre Install ###
###################

# Clean Home Directory
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
  ~/.bash_profile
clear

###############
### Install ###
###############

# Copy Files to Home Directory
echo "-----------------------------------------------------------------------"
echo "------------------- Copying files to Home directory -------------------"
echo "-----------------------------------------------------------------------"
cp -rv lib/.* ~/
cp -rv lib/* ~/
clear

####################
### Post Install ###
####################

# Change to Home Directory
cd ~/

# Link vim files to nvim (done to support both vim and neovim)
echo "-----------------------------------------------------------------------"
echo "-------------------------- Linking vim files --------------------------"
echo "-----------------------------------------------------------------------"
ln -sv ~/.config/nvim .vim
ln -sv ~/.config/nvim/init.vim .vimrc
clear

# Link .bash_profile to .profile
echo "-----------------------------------------------------------------------"
echo "------------------------ Linking bash_profile -------------------------"
echo "-----------------------------------------------------------------------"
ln -sv ~/.profile ~/.bash_profile
source ~/.bash_profile
clear

# Install Vim-Plug
echo "-----------------------------------------------------------------------"
echo "------------------------- Installing vim-plug -------------------------"
echo "-----------------------------------------------------------------------"
curl -fLov ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
clear

# Instructions to finish
echo "-----------------------------------------------------------------------"
echo "-------------------------- Install finished! --------------------------"
echo "-----------------------------------------------------------------------"
echo "    1: Launch vim"
echo "    2: Run :PlugInstall"
echo "    3: Run :so ~/.vimrc"
echo ""
