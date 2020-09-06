# Ensure encrypted drive is unmounted
[ -f /mnt/keychain ] && unmount_veracrypt

rm "$HOME/.*history"
