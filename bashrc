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

# Bash Prompts ########################################

PROMPT_HOST=$(hostname -f | sed -e 's/\.niftylogic\.net$//')
if [[ -x /sbin/ip ]]; then
	PROMPT_ADDR=$(/sbin/ip addr show 2>/dev/null | awk '/inet.* scope global / { print $2; exit }')
elif [[ -x /sbin/ifconfig ]]; then
	PROMPT_ADDR=$(/sbin/ifconfig en0 2>/dev/null | awk '/inet / { print $2; exit }')
else
	PROMPT_ADDR="::unknown::"
fi
[ -z $PROMPT_ADDR ] || PROMPT_ADDR="$PROMPT_ADDR "

PROMPT_TT=""
if [[ -x $HOME/bin/tt ]]; then
	PROMPT_TT='%C[$(tt --prompt):]'
fi

export PS1=$(echo "+%B[\t]:%Y[\!]:$PROMPT_TT"'$(r=$?; test $r -ne 0 && echo "%R[$r]" || echo "%Y[$r]")'" %M[$PROMPT_ADDR]%G[\u@$PROMPT_HOST] %B[\w\n]%G[→] " | $HOME/env/colorize);

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
if [[ "$(command -v brew)" != "" ]]; then
	export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
fi

if [[ -d $HOME/sw ]]; then
	export PATH="$PATH:$HOME/sw/bin"
	export LD_LIBRARY_PATH="$HOME/sw"
	export LDFLAGS="-L$HOME/sw/lib"
	export CFLAGS="-I$HOME/sw/include"
	export CPPFLAGS=$CFLAGS
	export PKG_CONFIG_PATH="$HOME/sw/lib/pkgconfig"
fi

for FILE in $HOME/env/*.bashrc; do
	[ -f $FILE ] && source $FILE
done

# Server-specific overrides ###########################

if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi
