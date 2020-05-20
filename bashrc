#!/bin/bash
#
# env/bashrc - Making bash feel like home
#

# VIM #################################################
export EDITOR=vim

# COLORS ##############################################
export CLICOLOR=1 # Mac OSX

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
alias rss='newsbeuter'
alias vo='vim -O'
alias ks='k -n kube-system'
alias dr='docker run -it --rm'

# Configure Environment ###############################
# V=0 causes quiet output from automake builds
export V=0

# cf cli is a bit too judgmental of slow foundries
export CF_DIAL_TIMEOUT=15

# Bash Prompts ########################################

PROMPT_HOST=
[ -f $HOME/.host  ] && PROMPT_HOST=$(cat $HOME/.host)
[ -z $PROMPT_HOST ] && PROMPT_HOST=$(hostname -f | sed -e 's/\.niftylogic\.net$//')

if [[ -x /sbin/ip ]]; then
	PROMPT_ADDR=$(/sbin/ip addr show 2>/dev/null | awk '/inet.* scope global / { print $2; exit }')
elif [[ -x /sbin/ifconfig ]]; then
	PROMPT_ADDR=$(/sbin/ifconfig en0 2>/dev/null | awk '/inet / { print $2; exit }')
else
	PROMPT_ADDR="::unknown::"
fi
[ -z $PROMPT_ADDR ] || PROMPT_ADDR="$PROMPT_ADDR "

PROMPT_TT=""
type tt >/dev/null 2>&1
if [[ $? == 0 ]]; then
	PROMPT_TT=':%C[$(tt --prompt)]'
fi

PROMPT_SHLVL=""
if [[ -z ${TMUX:-} && ${SHLVL:-} != 1 ]]; then
	PROMPT_SHLVL="%C[sh${SHLVL}] "
fi
if [[ -n ${TMUX:-} && ${SHLVL:-} != 2 ]]; then
	PROMPT_SHLVL="%C[sh$(( SHLVL - 1 ))] "
fi

PROMPT_K8S=""
if command -v kubectx > /dev/null; then
	PROMPT_K8S='%M[$(kubectx -c)]:%G[$(kubens -c)] +'
fi

export PS1=$(echo "$PROMPT_SHLVL+$PROMPT_K8S%B[\D{%%j+%%H:%%M:%%S}]:%Y[\!]:"'$(r=$?; test $r -ne 0 && echo "%R[$r]" || echo "%Y[$r]")'"$PROMPT_TT %M[$PROMPT_ADDR]%G[\u@$PROMPT_HOST] %B[\w\n]%G[→] " | $HOME/env/colorize);
if [[ -n ${SIMPLE:-} ]]; then
	export PS1=$(echo "%G[\u@$PROMPT_HOST] %B[\w\n]%G[→] " | $HOME/env/colorize);
fi

demomode() {
	export DEMO_MODE=yes
	export PS1=$(echo "%G[\u] %B[\w] %Y[→] " | $HOME/env/colorize);
	export PSGIT="$PS1 "
	clear
}
if [[ ${DEMO_MODE:-} = "yes" ]]; then
	demomode
fi

type git >/dev/null 2>&1
if [[ $? == 0 ]]; then
	export PSGIT="%{%[\e[1;34m%]%b%[\e[00m%]:%[\e[1;33m%]%i%[\e[00m%]%}%{%[\e[1;31m%]%c%u%f%t%[\e[00m%]) %}$PS1 "
	export PROMPT_COMMAND='export PS1=$($HOME/env/gitprompt c=\+ u=\* statuscount=1)'
fi

case ${TERM:-unknown} in
screen)
	if [[ -n $PROMPT_COMMAND ]]; then
		export PROMPT_COMMAND="$PROMPT_COMMAND;";
	fi
	export PROMPT_COMMAND=$PROMPT_COMMAND'echo -ne "\033]2;${USER}@${PROMPT_HOST} ${PROMPT_ADDR}${PWD}\033k${PROMPT_HOST}\033\\"'
	;;
esac

export LISP_PS1=$(echo -e "\033[1;36m🦄\033[0m ")' '

echo $PATH | grep -q "$HOME/bin";
if [[ $? != 0 ]]; then
	PATH="$PATH:$HOME/bin"
fi
if [[ "$(command -v brew)" != "" ]]; then
	PATH="/usr/local/sbin:/usr/local/bin:$PATH"
	MANPATH="/usr/share/man:/usr/local/share/man"

	# brew --prefix {core,inet}utils
	for pkg in {core,inet}utils; do
		if [[ -d /usr/local/opt/$pkg ]]; then
			PATH="/usr/local/opt/$pkg/libexec/gnubin:$PATH"
			MANPATH="/usr/local/opt/$pkg/share/man"
		fi
	done
	export PATH MANPATH

	if brew list | grep -q bash-completion; then
		source $(brew --prefix)/etc/bash_completion
	fi
fi

if [[ -d $HOME/sw ]]; then
	PATH="$PATH:$HOME/sw/sbin:$HOME/sw/bin"
	export LD_LIBRARY_PATH="$HOME/sw/lib"
	export LDFLAGS="-L$HOME/sw/lib"
	export CFLAGS="-I$HOME/sw/include"
	export CPPFLAGS=$CFLAGS
	export PKG_CONFIG_PATH="$HOME/sw/lib/pkgconfig"
fi

for FILE in $HOME/env/bash/*; do
	[ -f $FILE ] && source $FILE
done

# Server-specific overrides ###########################

if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi
if [ -f ~/.title ]; then
	title $(cat ~/.title)
fi

if [[ -n "$(command -v dircolors 2>/dev/null)" ]]; then
	eval $(dircolors)
	if ! ls --color=auto /enoent 2>&1 >/dev/null | grep -q illegal; then
		alias ls="ls --color=auto"
	fi
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
pathify -p $HOME/bin

cd() {
	builtin cd "$1" || return
	[ "${OLDPWD:-foo}" = "$PWD" ] || if [ -f "$PWD/WIP" ]; then
		echo; echo;
		echo "---[ WORK IN PROGRESS ]---------------------"
		echo "Date: $(stat -c %y "$PWD/WIP")"
		echo
		head -n 25 "$PWD/WIP"
		echo
		echo "---[ WORK IN PROGRESS ]---------------------"
		echo; echo
	fi
}

case ${OSTYPE:-UNKNOWN} in
linux-gnu)
	alias pbcopy='xclip -selection CLIPBOARD -i'
	alias pbpaste='xclip -selection CLIPBOARD -o'
	;;
esac
