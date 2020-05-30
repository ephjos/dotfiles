#!/bin/bash

# Copy all files
cp -rv . $HOME

# Link vim + nvim config files together for portability
rm $HOME/.vim $HOME/.vimrc
ln -sv $HOME/.config/nvim $HOME/.vim
ln -sv $HOME/.config/nvim/init.vim $HOME/.vimrc

# Cleanup extra copies
rm -rfv $HOME/{.git,dockerfile,LICENSE,install.sh,Makefile,README.md}


