# Copyright (c) 2014-2021 oxnz. All rights reserved.
#
# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in [openSUSE] setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
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

export CLICOLOR=1
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
   LESS_TERMCAP_mb=$'\E[01;32m' \
   LESS_TERMCAP_md=$'\E[01;36m' \
   LESS_TERMCAP_me=$'\E[0m' \
   LESS_TERMCAP_us=$'\E[01;04;32m' \
   LESS_TERMCAP_ue=$'\E[0;10m' \
   LESS_TERMCAP_so=$'\E[01;45;93m' \
   LESS_TERMCAP_se=$'\E[0;10m' \
   LESS_TERMCAP_mr=$'\E[7m' \
   LESS_TERMCAP_mh=$'\E[2m' \
   GROFF_NO_SGR=1 \
   command man "$@"
}


################################################################################
# alias definitions.
#-------------------------------------------------------------------------------
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
#-------------------------------------------------------------------------------

# make colorful grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# play safer
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# format aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias df='df -h'
alias du='du -h'

# disable banner
alias gdb='gdb --quiet'
alias bc='bc --quiet'

# typo
alias cd..='cd ..'
alias unmount='echo "Error: Try the command: umount" >&2 && false'

# shortcuts
alias e="${EDITOR:-vim}"
alias o='less'
alias h='history'
alias j='jobs -l'
alias -- +='pushd'
alias -- -='popd'
alias ..='cd ..'
alias ...='cd ../..'
alias x='extract'
alias rd='rmdir'
alias md='mkdir -p'
alias beep='printf "\007"'


# new commands
alias now='/bin/date +"%F %T"'
alias netstat6='netstat -A inet6'

# command not in PATH var {{{
case "$(uname -s)" in
	Linux)
		# platform compatible
		alias pbcopy='xsel --clipboard --input'
		alias pbcopy='xsel --clipboard --output'
		alias open='xdg-open'
		;;
esac

# ex: ts=4 sw=4 et filetype=sh
