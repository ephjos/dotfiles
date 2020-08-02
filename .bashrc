#!/usr/bin/env bash

# Load aliases
source "$HOME/.config/.aliasrc"

# Prompt
#export PS1="$(tput bold)$(tput setaf 1)$(tput setaf 3)\u$(tput setaf 2) in $(tput setaf 4)$(tput setaf 5)\W$(tput setaf 1)$(tput setaf 7) \\$ $(tput sgr0)"

# Path config
export PATH=$PATH:/usr/local/share:$HOME/.config/Scripts:$HOME/.scripts:/usr/lib/jvm/java-8-openjdk/bin/
export PATH=$PATH:/opt/ghdl/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:/Library/PostgreSQL/12/scripts
export PATH="$(du $HOME/.local/bin/ | cut -f2 | tr '\n' ':')$PATH"
export PATH=$PATH:$HOME/.local/share/npm/bin

# Default applications
export EDITOR="vim"
export FILE="ranger"
export TERMINAL="st"
export BROWSER="brave"

# Program configs
export FZF_DEFAULT_COMMAND="find ."

# Nicer setting for viewing dot status
git --git-dir=$HOME/repos/dotfiles/.git --work-tree=$HOME \
  config --local status.showUntrackedFiles no

# Ensure vim and nvim configs linked
[[ ! -e "$HOME/.vimrc" ]] && \
  ln -s "$HOME/.config/nvim/init.vim" "$HOME/.vimrc" &&
  ln -s "$HOME/.config/nvim" "$HOME/.vim"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ "`id -u`" -eq 0 ]; then
    PS1="\[\e[35m\]\H\[\e[0m\]:\[\e[36m\]\W \[\e[1;31m\]--> \[\e[0m\]"
else
    PS1="\[\e[35m\]\H\[\e[0m\]:\[\e[36m\]\W \[\e[1;32m\]-> \[\e[0m\]"
fi
