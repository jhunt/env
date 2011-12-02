#!/bin/bash
#
# env/bashrc - Making bash feel like home
#

# VIM #################################################
export EDITOR=vim

# Command Aliases #####################################
alias ll='ls -l'
alias la='ls -la'
alias lr='ls -ltr'
alias diff='diff -u'

# Bash Prompts ########################################

# figure out exit status of last command
function ps1_exit {
	if [[ $? = 0 ]]; then echo -e '\033[01;33m0\033[00m'
	else echo -e "\\033[01;31m$?\\033[00m"
	fi
}

#export PS1='\!:$?:\$ '
export PS1='\[\033[01;33m\]\!\[\033[00m\]:$(ps1_exit):\[\033[01;32m\]jh@\h\[\033[01;34m\] \w\[\033[00m\] \[\033[01;34m\]\$\[\033[00m\] '

export PS0="%{\[\033[1;34m\]%b\[\033[00m\]:\[\033[1;33m\]%i\[\033[00m\]%}%{\[\033[1;31m\]%c%u%f%t\[\033[00m\]) %}$PS1"
if [[ -z $ORIG_PROMPT_COMMAND ]]; then
	ORIG_PROMPT_COMMAND=$PROMPT_COMMAND
fi
export PROMPT_COMMAND=$ORIG_PROMPT_COMMAND';export PS1=$($HOME/env/gitprompt c=\+ u=\* statuscount=1)'
