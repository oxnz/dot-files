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

PS1='\[\e[01;34m\][\[\e[00m\]\[\e[00;36m\]\u\[\e[00;33m\]@\[\e[00;32m\]\h\[\e[01;32m\]:\[\e[00;36m\]\W\[\e[01;32m\]:\[\e[00;31m\]$?\[\e[01;34m\]]\$\[\e[00m\] '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

if [ -f ~/.shrc ]; then
	. ~/.shrc
fi
