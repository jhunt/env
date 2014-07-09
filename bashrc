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

PROMPT_HOST=$(hostname -f | sed -e 's/\.niftylogic\.net//')
PROMPT_ADDR=$(/sbin/ip addr show 2>/dev/null | awk '/inet.*(eth|bond|wlan)/ { print $2; exit }')
[ -z $PROMPT_ADDR ] || PROMPT_ADDR="$PROMPT_ADDR "

export PS1=$(echo "+%B[\t]:%Y[\!]:"'$(r=$?; test $r -ne 0 && echo "%R[$r]" || echo "%Y[$r]")'" %M[$PROMPT_ADDR]%G[\u@$PROMPT_HOST] %B[\w\n]%G[→] " | $HOME/env/colorize);

type git >/dev/null 2>&1
if [[ $? == 0 ]]; then
	export PS0="%{%[\e[1;34m%]%b%[\e[00m%]:%[\e[1;33m%]%i%[\e[00m%]%}%{%[\e[1;31m%]%c%u%f%t%[\e[00m%]) %}$PS1 "
	export PROMPT_COMMAND='export PS1=$($HOME/env/gitprompt c=\+ u=\* statuscount=1)'
fi

case $TERM in
screen)
	if [[ -n $PROMPT_COMMAND ]]; then
		export PROMPT_COMMAND="$PROMPT_COMMAND;";
	fi
	export PROMPT_COMMAND=$PROMPT_COMMAND'echo -ne "\033]2;${USER}@${PROMPT_HOST} ${PROMPT_ADDR}${PWD}\033k${PROMPT_HOST}\033\\"'
	;;
esac

echo $PATH | grep -q "$HOME/bin";
if [[ $? != 0 ]]; then
	export PATH="$PATH:$HOME/bin"
fi

for FILE in $HOME/env/*.bashrc; do
	[ -f $FILE ] && source $FILE
done

# Server-specific overrides ###########################

if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi
