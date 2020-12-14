#!/usr/bin/env bash

# Load aliases
source "$HOME/.config/.aliasrc"

# Path config
export PATH=$PATH:/usr/local/share:$HOME/.config/Scripts:$HOME/.scripts:/usr/lib/jvm/java-8-openjdk/bin/
export PATH=$PATH:/opt/ghdl/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:/Library/PostgreSQL/12/scripts
export PATH="$(du $HOME/.local/bin/ | cut -f2 | tr '\n' ':')$PATH"
export PATH=$PATH:$HOME/.local/share/npm/bin
export PATH="$HOME/.cargo/bin:$PATH"

# Default applications
export EDITOR="vim"
export FILE="ranger"
export TERMINAL="st"
export BROWSER="brave"

# Program configs
export FZF_DEFAULT_COMMAND="find ."

export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[45;93m'
export LESS_TERMCAP_se=$'\e[0m'

# Nicer setting for viewing dot status
[[ -e "$HOME/repos/dotfiles" ]] && \
  git --git-dir=$HOME/repos/dotfiles/.git --work-tree=$HOME \
    config --local status.showUntrackedFiles no

# Ensure vim and nvim configs linked
[[ ! -e "$HOME/.vimrc" ]] && \
  ln -s "$HOME/.config/nvim/init.vim" "$HOME/.vimrc" && \
  ln -s "$HOME/.config/nvim" "$HOME/.vim"

c="\[\e[0m\]"
pink="\[\e[38;5;168m\]"
cyan="\[\e[38;5;51m\]"
offwhite="\[\e[38;5;252m\]"
green="\[\e[38;5;83m\]"
red="\[\e[38;5;196m\]"

if [ "`id -u`" -eq 0 ]; then
    PS1="$cyan\u$c$offwhite@$c$pink\H$c $red\w$c #$c "
else
    PS1="$cyan\u$c$offwhite@$c$pink\H$c $green\w$c \$$c "
fi
