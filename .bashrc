#!/bin/sh

#
# :vars
#
export BASH_SILENCE_DEPRECATION_WARNING=1
export BROWSER="firefox"
export EDITOR="vim"
export FILE="lf"
export FZF_DEFAULT_COMMAND="rg --files --hidden --no-heading --follow --glob '!.git'"
export GTK_THEME=Adwaita:dark
export GTK_APPLICATION_PREFER_DARK_THEME=1
export LESSHISTFILE=-
export MallocNanoZone=0
export QT_QPA_PLATFORMTHEME=qt5ct
export TERMINAL="ghostty"

export BIN="$HOME/.local/bin"
export DESKTOP="$HOME/Desktop"
export DOCUMENTS="$HOME/Documents"
export DOWNLOAD="$HOME/Downloads"
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export MUSIC="$HOME/Music"
export PICTURES="$HOME/Pictures"
export PUBLICSHARE="$HOME/Public"
export SDKMAN_DIR="$HOME/.sdkman"
export TEMPLATES="$HOME/Templates"
export VIDEOS="$HOME/Videos"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DESKTOP_DIR="$DESKTOP"
export XDG_DOCUMENTS_DIR="$DOCUMENTS"
export XDG_DOWNLOAD_DIR="$DOWNLOAD"
export XDG_MUSIC_DIR="$MUSIC"
export XDG_PICTURES_DIR="$PICTURES"
export XDG_PUBLICSHARE_DIR="$PUBLICSHARE"
export XDG_TEMPLATES_DIR="$TEMPLATES"
export XDG_VIDEOS_DIR="$VIDEOS"
export XDG_RUNTIME_DIR="/run/user/$UID"

export ADB_VENDOR_KEY="$XDG_CONFIG_HOME/android"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOCKER_CONFIG="$XDG_DATA_HOME/docker"
export FNM_DIR="$XDG_DATA_HOME/fnm"
export FZF_HOME="$XDG_DATA_HOME/fzf"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export HISTFILE="$XDG_DATA_HOME/history"
export INPUTRC="$XDG_CONFIG_HOME/.inputrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PARALLEL_HOME="$XDG_DATA_HOME/parallel"
export PLTUSERHOME="$XDG_DATA_HOME/racket"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export SCREENSHOTS="$PICTURES/screenshots"
export STACK_ROOT="$XDG_DATA_HOME/stack"
export TERM=$TERMINAL
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export WALLPAPER="$XDG_DATA_HOME/wallpaper.png"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"

export NEWT_COLORS='
actbutton=#282828,#d65d0e
actcheckbox=#ebdbb2,#d65d0e
actcompactbutton=#282828,#d65d0e
actentry=#282828,#d65d0e
actlistbox=#d65d0e,#282828
actsellistbox=#282828,#d65d0e
acttextbox=#fabd2f,#d65d0e
border=#d5c4a1,#282828
button=#282828,#d65d0e
checkbox=#ebdbb2,#282828
compactbutton=#ebdbb2,#504945
disentry=#928374,#282828
emptyscale=#000000,#504945
entry=#ebdbb2,#282828
fullscale=#000000,#d65d0e
helpline=#d5c4a1,#504945
label=#d5c4a1,#282828
listbox=#ebdbb2,#282828
root=#ebdbb2,#282828
roottext=#d5c4a1,#282828
sellistbox=#ebdbb2,#d65d0e
textbox=#ebdbb2,#282828
title=#d65d0e,#282828
window=#ebdbb2,#282828
'

#
# :path
#
function addpath {
  export PATH="$PATH:$1";
}

export PATH=""
addpath "$BIN"
addpath "/usr/local/bin"
addpath "/usr/local/sbin"
addpath "/bin"
addpath "/sbin"
addpath "/usr/bin"
addpath "/usr/sbin"
addpath "./node_modules/.bin"
addpath "$HOME/.local/share/npm/bin"
addpath "$CARGO_HOME/bin"
addpath "$FZF_HOME/bin"
addpath "$FNM_DIR"

#
# :inits
# 
mkdir -p "$(dirname "$WGETRC")"
echo hsts-file \= "$XDG_CACHE_HOME"/wget-hsts > "$WGETRC"

# Activate brew env if present
[[ -f "/opt/homebrew/bin/brew" ]] && eval $(/opt/homebrew/bin/brew shellenv)

# Add all gnu coreutils overrides to path when on Mac
# https://apple.stackexchange.com/a/371984
if type brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do export MANPATH=$d:$MANPATH; done
fi

# Nicer setting for viewing dot status
[[ -e "$HOME/repos/dotfiles" ]] && \
  git --git-dir=$HOME/repos/dotfiles/.git --work-tree=$HOME \
    config --local status.showUntrackedFiles no

# Setup fzf
command -v fzf &> /dev/null || \
  (git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_HOME && \
    $FZF_HOME/install --bin)
source "$FZF_HOME/shell/key-bindings.bash"

# FNM
mkdir -p "$FNM_DIR"
command -v fnm &> /dev/null || \
  (curl -fsSL https://fnm.vercel.app/install | \
    bash -s -- --install-dir "$FNM_DIR" --skip-shell)
eval "`fnm env`"

# sdkman
[[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] || \
  (curl -s "https://get.sdkman.io" | \
    bash)

[[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

command -v go &> /dev/null && go telemetry off

#
# :prompt
# 
c="\[\e[0m\]"
offwhite="\[\e[38;5;252m\]"
red="\[\e[38;5;203m\]"
orange="\[\e[38;5;208m\]"
purple="\[\e[38;5;175m\]"
green="\[\e[38;5;142m\]"

if [ "`id -u`" -eq 0 ]; then # Root
    PS1="$red\u$c$offwhite@$c$purple\H$c $red\w$c #$c ";
else # User
    PS1="$orange\u$c$offwhite@$c$purple\H$c $green\w$c \$$c ";
fi

