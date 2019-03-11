#!/bin/bash
clear

echo "Building brew package list..."
brew list | awk '{print $0;}' > brew.pkg
echo ""

echo "Building cask package list..."
brew cask list | awk '{print $0;}' > cask.pkg
echo ""
