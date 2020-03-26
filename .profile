#
# ~/.profile
#

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

bind -f "$HOME/.config/.inputrc"

command -v nvim >/dev/null && export EDITOR="nvim"

