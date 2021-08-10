# Copyright (c) 2014-2021 oxnz. All rights reserved.
#
# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in [openSUSE] setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.
#
# you also need to put \[ and \] around any color codes so that bash does not
# take them into account when calculating line wraps. Also you can make use
# of the tput command to have this work in any terminal as long as the TERM
# is set correctly. For instance $(tput setaf 1) and $(tput sgr0)
# ref:
# http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

PS1='\[\e[01;34m\][\[\e[00m\]\[\e[00;36m\]\u\[\e[00;33m\]@\[\e[00;32m\]\h\[\e[01;32m\]:\[\e[00;36m\]\W\[\e[01;32m\]:\[\e[00;3$(($?==0?2:1))m\]$?\[\e[01;34m\]]\$\[\e[00m\] '

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# echo -en "\e]0;string\a" #-- Set icon name and window title to string
# echo -en "\e]1;string\a" #-- Set icon name to string
# echo -en "\e]2;string\a" #-- Set window title to string
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#	xterm*|rxvt*)
#		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h:\w\a\]$PS1"
#		;;
#	*)
#		;;
#esac

# prompt for bash
# There are several variables that can be set to control the appearance of the
# bach command prompt: PS1, PS2, PS3, PS4 and PROMPT_COMMAND the contents are
# executed just as if they had been typed on the command line.

# PS1 – Default interactive prompt (this is the variable most often customized)
# PS2 – Continuation interactive prompt (when a long command is broken up
#	    with \ at the end of the line) default=">"
# PS3 – Prompt used by “select” loop inside a shell script
# PS4 – Prompt used when a shell script is executed in debug mode
#       (“set -x” will turn this on) default ="++"
# PROMPT_COMMAND - If this variable is set and has a non-null value, then it
#		will be executed just before the PS1 variable.
# quote from tldp:
#	Bash provides an environment variable called PROMPT_COMMAND. The contents
#	of this variable are executed as a regular Bash command just before Bash
#	displays a prompt.

#prompt_command() {
#    GIT_PS1_SHOWUPSTREAM='auto' \
#    GIT_PS1_SHOWDIRTYSTATE='Y' \
#    GIT_PS1_SHOWSTASHSTATE='Y' \
#    GIT_PS1_SHOWCOLORHINTS='Y' \
#    GIT_PS1_SHOWUNTRACKEDFILES='Y' \
#	__git_ps1 "(%s)"
#}

# this may cause bash prompt messed up
#PROMPT_COMMAND=prompt_command


# Some applications read the EDITOR variable to determine the favourite editor
export EDITOR=/usr/bin/vim
export LESS='--no-init --RAW-CONTROL-CHARS --quit-if-one-screen'

man() {
#color
# 0: black 1: red 2 : green 3: yellow 4->blue 5:magenta, 6: cyan, 7:white # man terminfo
# LESS_TERMCAP_md: Start bold effect (double-bright).
# LESS_TERMCAP_me: Stop bold effect.
# LESS_TERMCAP_us: Start underline effect.
# LESS_TERMCAP_ue: Stop underline effect.
# LESS_TERMCAP_so: Start stand-out effect (similar to reverse text).
# LESS_TERMCAP_se: Stop stand-out effect (similar to reverse text).
# The format of the color code is easy to read once you understand it:
#
# The “\e” at the beginning identifies the sequence as a control code or escape sequence.
# The “m” at the end of the sequence command indicates the end of the command. It also causes the control code to be actioned.
# The numbers between the “[” and “m” dictate which colors will be used. The colors are identified by number. Some numbers represent background colors and some represent foreground (text) colors.
# These are the codes we’ll use to start a color sequence, and how to turn them all off:
#
# ‘\e[01;31m’: Black background, red text.
# ‘\e[01;32m’: Black background, green text.
# ‘\e[45;93m’: Magenta background, bright yellow text.
# ’‘\e[0m’: Turn off all effects.
	env LESS_TERMCAP_mb=$(tput bold; tput setaf 2) \
		LESS_TERMCAP_md=$(tput bold; tput setaf 6) \
		LESS_TERMCAP_me=$(tput sgr0)               \
		LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) \
		LESS_TERMCAP_se=$(tput rmso; tput sgr0)            \
		LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) \
		LESS_TERMCAP_ue=$(tput rmul; tput sgr0)            \
		LESS_TERMCAP_mr=$(tput rev)                        \
		LESS_TERMCAP_mh=$(tput dim)                        \
		LESS_TERMCAP_ZN=$(tput ssubm)                      \
		LESS_TERMCAP_ZV=$(tput rsubm)                      \
		LESS_TERMCAP_ZO=$(tput ssupm)                      \
		LESS_TERMCAP_ZW=$(tput rsupm)                      \
		GROFF_NO_SGR=1 \
		man "$@"
}                                                  \
		#GROFF_SGR=1 \
	#LESS_TERMCAP_md=$'\e[01;31m' \                 \
	#LESS_TERMCAP_me=$'\e[0m' \                     \
	#LESS_TERMCAP_us=$'\e[01;32m' \                 \
	#LESS_TERMCAP_ue=$'\e[0m' \                     \
	#LESS_TERMCAP_so=$'\e[45;93m' \                 \
	#LESS_TERMCAP_se=$'\e[0m' \                     \
	#GROFF_NO_SGR=1 \                               \
