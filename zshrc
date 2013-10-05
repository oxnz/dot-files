#!/bin/zsh
#
# Written by 0xnz<yunxinyi@gmail.com>
#
# Last updated: 2013-10-05 02:18:01

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return
PS1="[%n@%m %.]%# "

export CLICOLOR=1
export LC_ALL=en_US.UTF-8

# history settings
HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd..:cd.."
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# spelling correction options
#setopt CORRECT

# prompt for confirmation after 'rm *', etc.
setopt RM_STAR_WAIT

# don't write over existing files with >, use >! instead
setopt NOCLOBBER

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

zstyle ':completion:*' completer _expand _complete _match

autoload -Uz compinit
compinit

# get the colors
#autoload colors zsh/terminfo
#if [[ "$terminfo[colors]" -ge 8 ]]
#then
#	colors
#fi
#for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY
#do
#	eval C_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
#	eval C_L_$color='%{$fg[${(L)color}]%}'
#done
#C_OFF="%{$terminfo[sgr0]%}"
