#
# ~/.bashrc
#

#echo 'FROM BASHRC'
[ -n "$PS1" ] && source ~/.bash_profile

# If not running interactively, don't do anything
#[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
alias config='/usr/bin/git --git-dir=/home/boosung/.dotfiles --work-tree=/home/boosung'

export GTK_IM_MODULE=xim
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=xim
