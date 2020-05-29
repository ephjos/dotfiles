#!/bin/bash

# Copy all files
cp -rv . $HOME

# Link vim + nvim config files together for portability
[ -e $HOME/.vim ] || ln -sv $HOME/.config/nvim $HOME/.vim
[ -e $HOME/.vimrc ] || ln -sv $HOME/.config/nvim/init.vim $HOME/.vimrc

# Cleanup extra copies
rm -rfv $HOME/{.git,dockerfile,LICENSE,install.sh,Makefile,README.md}


