#!/bin/zsh
# File	: .zshrc
#
# Created: 2013-06-25 12:20:00
# Last-update: 2013-10-14 15:12:49
# Version: 0.1
# Author: Oxnz
# License: Copyright (C) 2013 Oxnz

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

export LC_ALL=en_US.UTF-8

# color{{{
autoload colors
colors

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
do
	eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval $color='%{$fg[${(L)color}]%}'
	(( count = $count + 1))
done
FINISH="%{$terminfo[sgr0]%}"

#}}}

#命令提示符
#prompt
#autoload -Uz promptinit
#promptinit
#prompt redhat
PROMPT=$(echo "[$CYAN%n@$YELLOW%m:$GREEN%.$_YELLOW$FINISH]%# ")

#zstyle ':vcs_info:*' enable git
#zstyle ':vcs_info:git*:*' git-revision true
#zstyle ':vcs_info:git*:*' check-for-changes false
#zstyle ':vcs_info:git*' formats "(%s) %12.12i %c%u %b%m"
#zstyle ':vcs_info:git*' actionformats "(%s|%a) %12.12i %c%u %b%m"

#标题栏、任务栏样式{{{
case $TERM in (*xterm|*rxvt*|(dt|k|E)term)
	precmd() { print -Pn "\e]0;%n@%M//%/\a" }
	preexec() { print -Pn "\e]0;%n@%M//%/\ $1\a" }
	;;
esac
#}}}

#编辑器
export EDITOR=vim

# python
export PYTHONSTARTUP=~/.pythonrc.py

#输入法
#export XMODIFIER$="@im=ibus"
#export QT_MODULE=ibus
#export GTK_MODULE=ibus

# Utils settings {{{
#允许在交互模式中使用注释  例如：
setopt INTERACTIVE_COMMENTS
#启用自动 cd，输入目录名回车进入目录,稍微有点混乱，不如 cd 补全实用
setopt AUTO_CD
#扩展路径
#/v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word

# disable core dumps
limit coredumpsize 0

###################################################
# Key bindings
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
#bindkey "\e[1~" beginning-of-line # Home
#bindkey "\e[4~" end-of-line # End
#bindkey -v
#bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~"	delete-char	# Del
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

#following chars are regareds as part of the word
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}

# completion {{{
#setopt AUTO_MENU
#with AUTO_LIST set, when the completion is ambiguous you get a list without
#having to type ^D
setopt AUTO_LIST
#开启此选项，补全时会直接选中菜单项
#setopt MENU_COMPLETE
# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
if whence dircolors >/dev/null; then
	eval "$(dircolors -b)"
else
	export CLICOLOR=1
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,%mem,tty,cputime,command'
#自动补全缓存
#zstyle ':complete::complete:*' use-cache on
#zstyle ':complete::complete:*' cache-path .zcache
#zstyle ':complete:*:cd:*' ignore-parents parent pwd

#自动补全选项
#zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect: lines: %L matches: %M [%p]'

zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# Path completion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

# Colorful menu completion
#eval $(dircolors -b)
#export ZLSCOLORS="${LS_COLORS}"
#zmodload zsh/complist
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Fix upper and lower case
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# correction
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Kill completion
zstyle ':completion:*:*:kill' menu yes select
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
compdef pkill=kill
compdef killall=kill

#补全类型提示分组
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}

# spelling correction options
#setopt CORRECT

# prompt for confirmation after 'rm *', etc.
#setopt RM_STAR_WAIT

# don't write over existing files with >, use >! instead
setopt NOCLOBBER

##行编辑高亮模式 {{{
# Ctrl+@ 设置标记，标记和光标点之间为 region
zle_highlight=(region:bg=magenta #选中区域
special:bold      #特殊字符
isearch:underline)#搜索时使用的关键字
#}}}
 
##空行(光标在行首)补全 "cd " {{{
user-complete(){
	case $BUFFER in
	"" )                       # 空行填入 "cd "
		BUFFER="cd "
		zle end-of-line
		zle expand-or-complete
		;;
	"cd --" )                  # "cd --" 替换为 "cd +"
		BUFFER="cd +"
		zle end-of-line
		zle expand-or-complete
		;;
	"cd +-" )                  # "cd +-" 替换为 "cd -"
		BUFFER="cd -"
		zle end-of-line
		zle expand-or-complete
		;;
	* )
		zle expand-or-complete
		;;
	esac
}
zle -N user-complete
bindkey "\t" user-complete
#}}}
 
##在命令前插入 sudo {{{
#定义功能
sudo-command-line() {
	[[ -z $BUFFER ]] && zle up-history
	[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
	zle end-of-line                 #光标移动到行末
}
zle -N sudo-command-line
#定义快捷键为： [Esc] [Esc]
bindkey "\e\e" sudo-command-line
#}}}

#aliases {{{
#[Esc][h] man 当前命令时，显示简短说明
alias run-help >&/dev/null && unalias run-help
autoload run-help
 
#历史命令 top10
#alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
#}}}

        
#自定义补全{{{
#补全 ping
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com
 
#补全 ssh scp sftp 等
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
#}}}

#{{{ F1 计算器
arith-eval-echo() {
LBUFFER="${LBUFFER}echo \$(( "
RBUFFER=" ))$RBUFFER"
}
zle -N arith-eval-echo
bindkey "^[[11~" arith-eval-echo
#}}}
 
####{{{
#function timeconv { date -d @$1 +"%Y-%m-%d %T" }
# }}}

zmodload zsh/mathfunc
autoload -U zsh-mime-setup
zsh-mime-setup

# If the EXTENDED_GLOB option is set, the ^, ~, and # characters also denote
# a pattern, some command depends on this special characters need to escape
# slash, like `git reset HEAD\^`, U can also `alias git="noglob git"`, a 3rd
# option: % noglob git show HEAD^
setopt EXTENDED_GLOB

#setopt correctall
autoload compinstall
     
#漂亮又实用的命令高亮界面
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')

recolor-cmd() {
	region_highlight=()
	colorize=true
	start_pos=0
	for arg in ${(z)BUFFER}; do
		((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
		((end_pos=$start_pos+${#arg}))
		if $colorize; then
			colorize=false
			res=$(LC_ALL=C builtin type $arg 2>/dev/null)
			case $res in
				*'reserved word'*)   style="fg=magenta,bold";;
				*'alias for'*)       style="fg=cyan,bold";;
				*'shell builtin'*)   style="fg=yellow,bold";;
				*'shell function'*)  style='fg=green,bold';;
				*"$arg is"*)
					[[ $arg = 'sudo' ]] && style="fg=red,bold" || style="fg=blue,bold";;
				*)                   style='none,bold';;
			esac
			region_highlight+=("$start_pos $end_pos $style")
		fi
		[[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
		start_pos=$end_pos
	done
}
check-cmd-self-insert() { zle .self-insert && recolor-cmd }
check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd }

zle -N self-insert check-cmd-self-insert
zle -N backward-delete-char check-cmd-backward-delete-char


if [ -f ~/.shrc ]; then
	. ~/.shrc
fi


for file in ~/.shell/*
do
	if [ -r $file ]; then
		. $file
	fi
done
