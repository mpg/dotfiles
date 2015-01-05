# ~/.zprofile
#
# Work around an issue with Arch Linux (2015-01-05):
# The global zprofile resets PATH, undoing our work from ~/.zshenv
# So, reload it here if we seem to be running an affected version.

test -e /usr/bin/pacman || return
grep 'source /etc/profile' /etc/zsh/zprofile >/dev/null 2>&1 || return

. "$HOME"/.zshenv
