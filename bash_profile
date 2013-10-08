#!/bin/bash

case $- in
	*i*)	# interactive shell
		;;
	*)	# non-interactive shell
		return
		;;
esac

#PS1='[\u@\h \W]\$ '
PS1="\[\e[0m\][\[\e[1;33m\]\u\[\e[1;31m\]@\h\[\e[1;31m\] \[\e[1;35m\]\W\[\e[1;35m\]\[\e[0m\]]\[\e[1;37m\]$ \[\e[0m\]"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /usr/local/etc/bash_completion ] && ! shopt -oq posix; then
    . /usr/local/etc/bash_completion
fi

for file in ~/.shell/*
do
	if [ -r $file ]; then
		. $file
	fi
done
