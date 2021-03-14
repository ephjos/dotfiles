#
# ~/.profile
#

[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

command -v nvim >/dev/null && export EDITOR="nvim"

# Copy .base files
find ~ -type f -name '*.efbase' -print0 2> /dev/null | sed -ze "p;s/.efbase$//" | xargs -0 -r -n2 cp -nv
