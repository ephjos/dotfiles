#!/bin/bash
clear

echo "Installing brew packages..."
brew install $(cat brew.pkg)
echo ""

echo "Installing cask packages..."
brew cask install $(cat cask.pkg)
echo ""
