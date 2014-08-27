# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# see http://tiswww.case.edu/php/chet/bash/{CHANGES,COMPAT,NEWS}
# see http://mywiki.wooledge.org/BashGuide
# see http://wiki.bash-hackers.org/doku.php
# see http://mywiki.wooledge.org/BashPitfalls

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

PS1='\[\e[01;34m\][\[\e[00m\]\[\e[00;36m\]\u\[\e[00;33m\]@\[\e[00;32m\]\h\[\e[01;32m\]:\[\e[00;36m\]\W\[\e[01;32m\]:\[\e[00;3$(($?==0?2:1))m\]$?\[\e[01;34m\]]\$\[\e[00m\] '

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h:\w\a\]$PS1"
		;;
	*)
		;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
		echo "YES"
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	elif [ -f /usr/local/share/bash-completion/bash-completion ]; then
		. /usr/local/share/bash-completion/bash-completion
	elif [ -f /usr/local/etc/bash_completion ]; then
	    . /usr/local/etc/bash_completion
	fi
fi

# source commen settings
if [ -f ~/.shrc ]; then
	. ~/.shrc
fi

if [ -d ~/.shell ]; then
	for i in ~/.shell/*.{ba,}sh; do
		if [ -r $i ]; then
			. $i
		fi
	done
	unset i
fi
