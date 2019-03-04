#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

stty -ixon

export PATH=$PATH:$HOME/.config/Scripts:$HOME/.scripts:/usr/lib/jvm/java-8-openjdk/bin/
export EDITOR="vim"
export TERMINAL="st"
export BROWSER="firefox"
