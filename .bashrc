#!/usr/bin/env bash

# Load aliases
source "$HOME/.config/.aliasrc"

# Path config
function addpath {
  export PATH="$PATH:$1";
}

export PATH=""
addpath "/usr/local/bin"
addpath "/usr/local/sbin"
addpath "/bin"
addpath "/sbin"
addpath "/usr/bin"
addpath "/usr/sbin"
addpath "./node_modules/.bin"
addpath "$HOME/.local/bin"
addpath "$HOME/.local/share/npm/bin"
addpath "$HOME/.cargo/bin"
addpath "$HOME/bin"
addpath "$HOME/.config/.fzf/bin"

# Default applications
export EDITOR="nvim"
export FILE="ranger"
export TERMINAL="st"
export BROWSER="brave"

# Program configs
export FZF_DEFAULT_COMMAND="find ."

export LESS="-R"
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# Nicer setting for viewing dot status
[[ -e "$HOME/repos/dotfiles" ]] && \
  git --git-dir=$HOME/repos/dotfiles/.git --work-tree=$HOME \
    config --local status.showUntrackedFiles no

# Ensure vim and nvim configs linked
[[ ! -e "$HOME/.vimrc" ]] && \
  ln -s "$HOME/.config/nvim/init.vim" "$HOME/.vimrc" && \
  ln -s "$HOME/.config/nvim" "$HOME/.vim"

# Prompt
c="\[\e[0m\]"
pink="\[\e[38;5;168m\]"
cyan="\[\e[38;5;51m\]"
offwhite="\[\e[38;5;252m\]"
green="\[\e[38;5;83m\]"
red="\[\e[38;5;196m\]"

if [ "`id -u`" -eq 0 ]; then # Root
    PS1="$cyan\u$c$offwhite@$c$pink\H$c $red\w$c #$c ";
else # User
    PS1="$cyan\u$c$offwhite@$c$pink\H$c $green\w$c \$$c ";
fi

# Setup fzf
[[ $- == *i* ]] && source "$HOME/.config/.fzf/shell/completion.bash" 2> /dev/null

source "$HOME/.config/.fzf/shell/key-bindings.bash"

# NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# sd completion
[[ -e "$HOME/.local/bin/_sd_complete" ]] && \
  source "$HOME/.local/bin/_sd_complete"

# Keychain
command -v keychain >/dev/null \
  && eval $(keychain --eval --quiet --nogui \
    $(find ~/.ssh -name "*.pub" | sed 's/.pub$//' | tr '\n' ' '));
