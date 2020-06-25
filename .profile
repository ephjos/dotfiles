#
# ~/.profile
#

[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
dots config --local status.showUntrackedFiles no

command -v nvim >/dev/null && export EDITOR="nvim"

