# For directory and config shortcuts:
source ~/.bash_shortcuts

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

#export PS1="[\u@\h \w]\`git_color\`\`parse_git_branch\` \`echo -e $COLOR_RESET\`\t\n\\$ "

if [ "$EUID" -ne 0 ]
	then export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\`git_color\`\`parse_git_branch\`\`echo -e $COLOR_RESET\`\n\\$ \[$(tput sgr0)\]"
	else export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]ROOT\[$(tput setaf 2)\]@\[$(tput setaf 4)\]$(hostname | awk '{print toupper($0)}') \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\`git_color\`\`parse_git_branch\`\`echo -e $COLOR_RESET\`\n\\$ \[$(tput sgr0)\]"
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


