# For directory and config shortcuts:
source ~/.bash_shortcuts

COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ $git_status =~ "Changes not staged" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Changes staged for commit" ]]; then
    echo -e $COLOR_OCHRE
  elif [[ $git_status =~ "Your branch is ahead" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo " -> $branch"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo " -> $commit"
  fi
}

export PS1

#Setting Bash prompt. Capitalizes username and host if root user (my root user uses this same config file).
if [ "$EUID" -ne 0 ]
	then export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\[\$(git_color)\]\$(git_branch)\$(echo -e $COLOR_RESET)\n\\$ \[$(tput sgr0)\]"
	else export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]ROOT\[$(tput setaf 2)\]@\[$(tput setaf 4)\]$(hostname | awk '{print toupper($0)}') \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\n\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
fi



#Generic shortcuts:
alias music="ncmpcpp"
alias clock="ncmpcpp -s clock"
alias visualizer="ncmpcpp -s visualizer"
alias news="newsbeuter"
alias email="neomutt"
alias files="ranger"
alias chat="weechat"
alias audio="ncpamixer"
alias calender="calcurse"
alias getmail="offlineimap && notmuch new"
alias gm="offlineimap && notmuch new"
alias theme="(cat ~/.cache/wal/sequences &)"
alias l="ls -al"
alias up="packer -Syu --noconfirm"
alias editVue="cd ~/repos/learning-vue-js/my-project/src"
alias editPandoc="cd ~/repos/pandoc-resume"

# SSH
alias tux="ssh jth95@tux.cs.drexel.edu"
alias website="ssh -i "/home/joseph/Documents/important/ec2-site.pem" ubuntu@ec2-18-188-139-134.us-east-2.compute.amazonaws.com"
alias deployVue="scp -i "/home/joseph/Documents/important/ec2-site.pem" -r /home/joseph/repos/learning-vue-js/my-project/dist/ ubuntu@ec2-18-188-139-134.us-east-2.compute.amazonaws.com:~/ && website && exit"


