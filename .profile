#
# ~/.profile
#

# Keychain
command -v keychain >/dev/null \
  && eval $(keychain --eval --quiet --nogui \
    $(find ~/.ssh -name "*.pub" | sed 's/.pub$//' | tr '\n' ' '));


