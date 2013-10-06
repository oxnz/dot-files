#!/bin/bash

#PS1='[\u@\h \W]\$ '
PS1="\[\e[0m\][\[\e[1;33m\]\u\[\e[1;31m\]@\h\[\e[1;31m\] \[\e[1;35m\]\W\[\e[1;35m\]\[\e[0m\]]\[\e[1;37m\]$ \[\e[0m\]"
export CLICOLOR=1
export LC_ALL=en_US.UTF-8

pathmunge() {
	case ":${PATH}:" in
		*:"$1":* | "$1:${PATH}:")
			# $1 is already contained or $1 is NIL
			;;
		*)
			if [ "$2" = "after" ]
			then
				PATH=$PATH:$1
			else
				PATH=$1:$PATH
			fi
	esac
}
#[ -d "/usr/local/mysql" ] && pathmunge "/usr/local/mysql/bin" "after"
#[ -d "/Users/xinyi/Workspace/android-sdks/platform-tools" ] && pathmunge "/Users/xinyi/Workspace/android-sdks/platform-tools" "after"
[ -d "/Applications/Qt/Qt5.1.1/5.1.1/clang_64/bin" ] && pathmunge "/Applications/Qt/Qt5.1.1/5.1.1/clang_64/bin" "after"

unset pathmunge

if [ -d "/etc/profile.d" ]
then
	for i in /etc/profile.d/*.sh
	do
		if [ -r "$i" ]
		then
			if [ "$PS1" ]
			then
				. "$i"
			else
				. "$i" > /dev/null 2>&1
			fi
		fi
	done
	unset i
fi

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd..:cd.."

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /usr/local/etc/bash_completion ] && ! shopt -oq posix; then
    . /usr/local/etc/bash_completion
fi

man () {
	env \
	LESS_TERMCAP_mb=$(printf "\e[1;31m") \
	LESS_TERMCAP_md=$(printf "\e[1;31m") \
	LESS_TERMCAP_me=$(printf "\e[0m") \
	LESS_TERMCAP_se=$(printf "\e[0m") \
	LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
	LESS_TERMCAP_ue=$(printf "\e[0m") \
	LESS_TERMCAP_us=$(printf "\e[1;32m") \
	man "$@"
}
