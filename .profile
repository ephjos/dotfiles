#
# ~/.profile
#

[[ -f "$HOME/.config/.cleanrc" ]] && source "$HOME/.config/.cleanrc"

[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

bind -f "$HOME/.config/.inputrc"

command -v nvim >/dev/null && export EDITOR="nvim"

