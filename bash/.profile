#
# ~/.profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.ghcup/env ]] && . ~/.ghcup/env

bind -f ~/.inputrc

export PATH=$PATH:/usr/local/share:$HOME/.config/Scripts:$HOME/.scripts:/usr/lib/jvm/java-8-openjdk/bin/
export PATH=$PATH:/opt/ghdl/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:/Library/PostgreSQL/12/scripts
export PATH="$(du $HOME/.local/bin/ | cut -f2 | tr '\n' ':')$PATH"

export EDITOR="vim"
export FILE="ranger"
export TERMINAL="st"

command -v nvim >/dev/null && export EDITOR="nvim"

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
