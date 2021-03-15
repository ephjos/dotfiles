#
# ~/.profile
#

[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

command -v nvim >/dev/null && export EDITOR="nvim"

# Copy .base files
copy_base() {
  BASE="$1";
  REAL="$(echo "$1" | sed -e 's/.base$//')";
  cp -nv "$BASE" "$REAL";
}

copy_base ~/.config/npm/npmrc.base
copy_base ~/.config/user-dirs.dirs.base
