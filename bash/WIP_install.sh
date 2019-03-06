#!/bin/bash

cp -r *.* ~/

cd ~/

rm -rf ~/.vim ~/.vimrc

ln -s ~/.config/nvim .vim
ln -s ~/.config/nvim/init.vim .vimrc
