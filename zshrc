#!/bin/zsh
#
# Written by 0xnz<yunxinyi@gmail.com>
#
# Last updated: 2013-10-05 02:18:01

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

export CLICOLOR=1
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
#autoload -U promptinit
#promptinit
#prompt redhat
PROMPT=$(echo "[$CYAN%n@$YELLOW%M:$GREEN%.$_YELLOW$FINISH]%# ")

#标题栏、任务栏样式{{{
case $TERM in (*xterm|*rxvt*|(dt|k|E)term)
	precmd() { print -Pn "\e]0;%n@%M//%/\a" }
	preexec() { print -Pn "\e]0;%n@%M//%/\ $1\a" }
	;;
esac
#}}}

#编辑器
export EDITOR=vim

#输入法
#export XMODIFIER$="@im=ibus"
#export QT_MODULE=ibus
#export GTK_MODULE=ibus

# history settings {{{
HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd..:cd.."
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
#为历史纪录中的命令添加时间戳
setopt EXTENDED_HISTORY
#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
#在命令前添加空格，不将此命令添加到纪录文件中
setopt HIST_IGNORE_SPACE
#}}}

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

# Emacs style key binding
bindkey -e
#bindkey -v
# set [DEL] to delete forward
bindkey "\e[3~"	delete-char

#following chars are regareds as part of the word
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}

# completion {{{
setopt AUTO_LIST
setopt AUTO_MENU
#开启此选项，补全时会直接选中菜单项
setopt MENU_COMPLETE
autoload -Uz compinit
compinit

#自动补全缓存
#zstyle ':complete::complete:*' use-cache on
#zstyle ':complete::complete:*' cache-path .zcache
#zstyle ':complete:*:cd:*' ignore-parents parent pwd

#自动补全选项
zstyle ':completion:*' verbose yes
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
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Kill completion
zstyle ':completion:*:*:kill' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

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
setopt RM_STAR_WAIT

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
alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
#}}}

#路径别名 {{{
#进入相应的路径时只要 cd ~xxx
	hash -d E="/etc/"
	hash -d WORK="/Users/xinyi/Documents/workspace"
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
function timeconv { date -d @$1 +"%Y-%m-%d %T" }
# }}}

zmodload zsh/mathfunc
autoload -U zsh-mime-setup
zsh-mime-setup
setopt EXTENDED_GLOB
    
setopt correctall
autoload compinstall
     
#漂亮又实用的命令高亮界面
setopt extended_glob
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


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
