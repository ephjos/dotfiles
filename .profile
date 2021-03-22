#
# ~/.profile
#

# Keychain
command -v keychain >/dev/null \
  && eval $(keychain --eval --quiet --nogui \
    $(find ~/.ssh -name "*.pub" | sed 's/.pub$//' | tr '\n' ' '));

# Copy .base files
copy_base() {
  BASE="$1";
  REAL="$(echo "$1" | sed -e 's/.base$//')";
  cp -nv "$BASE" "$REAL";
}

copy_base ~/.config/npm/npmrc.base
copy_base ~/.config/user-dirs.dirs.base

