# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

if [ "$color_prompt" = yes ]; then
	PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ '
else
	PS1='[${debian_chroot:+($debian_chroot)}\u@\h:\W]\$ '
fi
#PS1="\[\e[0m\][\[\e[1;33m\]\u\[\e[1;31m\]@\h\[\e[1;31m\]:\[\e[1;35m\]\W\[\e[1;35m\]\[\e[0m\]]\[\e[1;39m\]\$ \[\e[0m\]"
PS1="[\[\e[1;33m\]\u\[\e[1;31m\]@\h\[\e[1;32m\]:\[\e[1;36m\]\W\[\e[m\]]\$ "

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

for file in ~/.shell/*
do
	if [ -r $file ]; then
		. $file
	fi
done
