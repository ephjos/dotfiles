#!/usr/bin/env bash

# Load aliases
source "$HOME/.config/.aliasrc"

# Prompt
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

# Path config
export PATH=$PATH:/usr/local/share:$HOME/.config/Scripts:$HOME/.scripts:/usr/lib/jvm/java-8-openjdk/bin/
export PATH=$PATH:/opt/ghdl/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:/Library/PostgreSQL/12/scripts
export PATH="$(du $HOME/.local/bin/ | cut -f2 | tr '\n' ':')$PATH"

# Default applications
export EDITOR="vim"
export FILE="ranger"
export TERMINAL="st"
export BROWSER="chromium"

# Program configs
export FZF_DEFAULT_COMMAND="find ."

[[ -f ~/.ghcup/env ]] && . ~/.ghcup/env
