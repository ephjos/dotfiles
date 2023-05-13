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
addpath "$CARGO_HOME/bin"
addpath "$HOME/.config/.fzf/bin"
addpath "$HOME/.dotnet/tools"

# Add all gnu coreutils overrides to path when on Mac
# https://apple.stackexchange.com/a/371984
if type brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do export MANPATH=$d:$MANPATH; done
fi


# Default applications
export EDITOR="nvim"
alias vim="nvim"
alias vi="nvim"

export FILE="lf"
export TERMINAL="xterm-256color"
export TERM="xterm-256color"
export BROWSER="brave"

# Program configs
export FZF_DEFAULT_COMMAND="rg --files --hidden --no-heading --follow --glob '!.git'"

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
source "$HOME/.config/.fzf/shell/key-bindings.bash"

# FNM
FNM_DIR="$HOME/.config/fnm"
mkdir -p "$FNM_DIR"
addpath "$FNM_DIR"
command -v fnm &> /dev/null || \
  (curl -fsSL https://fnm.vercel.app/install | \
    bash -s -- --install-dir "$FNM_DIR" --skip-shell)
eval "`fnm env`"

# sd completion
[[ -e "$HOME/.local/bin/_sd_complete" ]] && \
  source "$HOME/.local/bin/_sd_complete"

