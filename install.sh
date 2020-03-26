#!/bin/bash

cp -rv ./.bashrc $HOME/
cp -rv ./.profile $HOME/
ln -sv $HOME/.profile $HOME/.bash_profile

mkdir -p $HOME/.config/nvim
cp -rv ./.config/nvim/* $HOME/.config/nvim
cp -rv ./.config/nvim/.* $HOME/.config/nvim
ln -sv $HOME/.config/nvim $HOME/.vim
ln -sv $HOME/.config/nvim/init.vim $HOME/.vimrc

mkdir -p $HOME/.local/bin
cp -rv ./.local/bin/* $HOME/.local/bin
cp -rv ./.local/bin/.* $HOME/.local/bin

mkdir -p $HOME/.cabal
cp -rv ./.cabal/* $HOME/.cabal
cp -rv ./.cabal/.* $HOME/.cabal

