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
if [[ -x /usr/bin/colordiff ]]; then
	alias diff='/usr/bin/colordiff -u'
else
	alias diff='/usr/bin/diff -u'
fi
alias vgmem='valgrind --leak-check=full --show-reachable=yes'

# Screen SSH_AUTH_SOCK Support #######################

_ssh_auth_save() {
	mkdir -p $HOME/.screen
	ln -sf "$SSH_AUTH_SOCK" "$HOME/.screen/ssh-auth-sock.$HOSTNAME"
	echo "auth sock: $SSH_AUTH_SOCK"
}
alias screen='_ssh_auth_save; export HOSTNAME=$(hostname); screen'
alias s='_ssh_auth_save; export HOSTNAME=$(hostname); s'

# Bash Prompts ########################################

#export PS1='\!:$?:\$ '
export PS1='\[\e[01;33m\]\!\[\e[00m\]:`r=$?; test $r -ne 0 && echo "\[\e[1;31m\]$r\[\e[00m\]" || echo "\[\e[01;33m\]$r\[\e[00m\]"`:\[\e[01;32m\]jh@\h\[\e[01;34m\] \w\[\e[00m\] \[\e[01;34m\]\$\[\e[00m\] '

export PS0="%{%[\e[1;34m%]%b%[\e[00m%]:%[\e[1;33m%]%i%[\e[00m%]%}%{%[\e[1;31m%]%c%u%f%t%[\e[00m%]) %}$PS1\n: "
if [[ -z $ORIG_PROMPT_COMMAND && ! -z $PROMPT_COMMAND ]]; then
	ORIG_PROMPT_COMMAND="$PROMPT_COMMAND;"
fi
export PROMPT_COMMAND=$ORIG_PROMPT_COMMAND'export PS1=$($HOME/env/gitprompt c=\+ u=\* statuscount=1)'


echo $PATH | grep -q "$HOME/bin";
if [[ $? != 0 ]]; then
	export PATH="$PATH:$HOME/bin"
fi

source $HOME/env/git.bashrc
