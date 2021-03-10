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

# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.config/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.config/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.config/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.config/.fzf/shell/key-bindings.bash"

# NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Keychain
command -v keychain >/dev/null \
  && eval $(keychain --eval --quiet --nogui \
       $(ls -1 $HOME/.ssh | egrep -v "(\.|known_hosts|config)")) \
  || echo "keychain not installed...";
