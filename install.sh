#!/bin/bash

cp -rv ./bash/* $HOME/
cp -rv ./bash/.* $HOME/
ln -sv $HOME/.profile $HOME/.bash_profile

mkdir -p $HOME/.config/nvim
cp -rv ./vim/* $HOME/.config/nvim
cp -rv ./vim/.* $HOME/.config/nvim
ln -sv $HOME/.config/nvim $HOME/.vim
ln -sv $HOME/.config/nvim/init.vim $HOME/.vimrc

mkdir -p $HOME/.local/bin
cp -rv ./scripts/* $HOME/.local/bin
cp -rv ./scripts/.* $HOME/.local/bin

mkdir -p $HOME/.cabal
cp -rv ./.cabal/* $HOME/.cabal
cp -rv ./.cabal/.* $HOME/.cabal

