# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='\[\033[01;34m\][\[\033[00m\]\[\033[01;33m\]\u\[\033[01;31m\]@\[\033[01;32m\]\h\[\033[01;32m\]:\[\033[01;36m\]\W:\[\033[00;36m\]$?\[\033[01;34m\]]\$\[\033[00m\] '

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
