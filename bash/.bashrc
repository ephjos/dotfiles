# For directory and config shortcuts:
source ~/.bash_shortcuts

NOGIT="true"

if [[ $NOGIT == "true" ]]; then
    echo "Disabling git info in prompt"

    if [ "$EUID" -ne 0 ]; then
        export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\[$(tput setaf 2)\]\[$(tput sgr0)\]\n\\$ \[$(tput sgr0)\]"
    else
        export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]ROOT\[$(tput setaf 2)\]@\[$(tput setaf 4)\]$(hostname | awk '{print toupper($0)}') \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\n\\$ \[$(tput sgr0)\]"
    fi

else
    echo "Using git prompt"

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

    # get current branch in git repo
    function parse_git_branch() {
	    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	    if [ ! "${BRANCH}" == "" ]
	    then
		    STAT=`parse_git_dirty`
		    echo " -> ${BRANCH}${STAT}"
	    else
		    echo ""
	    fi
    }

    # get current status of git repo
    function parse_git_dirty {
	    status=`git status 2>&1 | tee`
	    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	    bits=''
	    if [ "${renamed}" == "0" ]; then
		    bits=">${bits}"
	    fi
	    if [ "${ahead}" == "0" ]; then
		    bits="*${bits}"
	    fi
	    if [ "${newfile}" == "0" ]; then
		    bits="+${bits}"
	    fi
	    if [ "${untracked}" == "0" ]; then
		    bits="?${bits}"
	    fi
	    if [ "${deleted}" == "0" ]; then
		    bits="x${bits}"
	    fi
	    if [ "${dirty}" == "0" ]; then
		    bits="!${bits}"
	    fi
	    if [ ! "${bits}" == "" ]; then
		    echo " ${bits}"
	    else
		    echo ""
	    fi
    }

    if [ "$EUID" -ne 0 ]
	    then export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\`git_color\`\`parse_git_branch\`\`echo -e $COLOR_RESET\`\n\\$ \[$(tput sgr0)\]"
	    else export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]ROOT\[$(tput setaf 2)\]@\[$(tput setaf 4)\]$(hostname | awk '{print toupper($0)}') \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\`git_color\`\`parse_git_branch\`\`echo -e $COLOR_RESET\`\n\\$ \[$(tput sgr0)\]"
    fi
fi

# My Shortcuts
alias l="ls -al"
alias up="packer -Syu --noconfirm"

# Generic shortcuts:
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
alias reload="source ~/.bash_profile"

# Git
alias gs="git status -sb"
alias gsv="git status -vvb"

alias ga="git add"
alias gr="git rm"
alias gcm="git commit -m"
alias gp="git push"

alias gb="git branch -v"
alias gd="git diff --color-words"

alias gl="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# Yarn
alias y='yarn'

alias yr='yarn run'
alias yrs='yarn run start'
alias yrt='yarn run test'
alias yrb='yarn run build'

alias ya='yarn add'
alias yrm='yarn remove'

alias yu='yarn upgrade-interactive --latest'

alias yga='yarn global add'
alias ygrm='yarn global remove'
alias ygu='yarn global upgrade-interactive --latest'

