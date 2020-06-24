#
# ~/.bash_profile
#

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi

# Luke Smith configuration
# PS1 configuration
prompt_git() {
	local s='';
	local branchName='';
	# Check if the current directory is in a Git repository
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
		# Check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
			# Ensure the index is up to date
			git update-index --really-refresh -q &>/dev/null;
			# Check for uncommitted changes in the index
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;
			# Check for unstaged changes
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;
			# Check for untracked files
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;
			# Check for stashed files
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;
		fi;
		# Get the short symbolic ref
		# If head isn't a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";
		[ -n "${s}" ] && s=" [${s}]";
		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}


# Color
bold=$(tput bold)
red=$(tput setaf 9)
yellow=$(tput setaf 228)
green=$(tput setaf 71)
orange=$(tput setaf 166)
white=$(tput setaf 15)
reset=$(tput sgr0)
blue=$(tput setaf 153)

PS1="\[${bold}\]";
PS1+="\[${red}\]["
PS1+="\[${orange}\]\u"
PS1+="\[${reset}\]\[${white}\]@\[${bold}\]"
PS1+="\[${yellow}\]\h ";
PS1+="\[${green}\]\W";
PS1+="\[${red}\]]"
PS1+="\$(prompt_git \" \[${blue}\]\"\"\[${blue}\]\")"; #Git repository details
PS1+="\[${reset}\] \[${white}\]$ \[${reset}\]";
export PS1;

# Some shopt
# Allows user to auto cd into directory merely by typing the directory name
#shopt -s autocd

#[[ -f ~/.bashrc ]] && . ~/.bashrc
