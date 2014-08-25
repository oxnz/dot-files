# Switches for shell control

export CLICOLOR=1
export LC_ALL=en_US.UTF-8

HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd..:cd.."
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTFILE="$HOME/.sh_history"
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=100000
HISTSIZE=10000
# for tcsh
SAVEHIST=$HISTSIZE

#{{{ Utils Settings
# bash shell settings
if [ -n "$BASH_VERSION" ]; then
    # If set, the pattern "**" used in a pathname expansion context will
    # match all files and zero or more directories and subdirectories.
    #shopt -s globstar
	shopt -s histappend     # append to the history file, don't overwrite it
	shopt -s cdspell		# Correct minor misspelling
	shopt -s dotglob		# Includes dotfiles in path expansion
	shopt -s checkwinsize	# Redraw contents if win size changes
	shopt -s cmdhist		# Multiline cmd records as one cmd in history
	shopt -s extglob		# Allow basic regexps in bash
    #shopt -s histverify     # Allow further modification other than exec immediately
    #shopt -s lithist        # Preserve the multiline history
elif [ -n "$ZSH_VERSOIN" ]; then
    # command not found support
    [[ -r /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

    # disable core dumps
    limit coredumpsize 0
    #扩展路径
    #/v/c/p/p => /var/cache/pacman/pkg
    setopt complete_in_word

    # spelling correction options
    #setopt CORRECT

    # prompt for confirmation after 'rm *', etc.
    #setopt RM_STAR_WAIT
    # don't write over existing files with >, use >! instead
    setopt NOCLOBBER
    #允许在交互模式中使用注释  例如：
    setopt INTERACTIVE_COMMENTS
    #启用自动 cd，输入目录名回车进入目录,稍微有点混乱，不如 cd 补全实用
    setopt AUTO_CD

    # If the EXTENDED_GLOB option is set, the ^, ~, and # characters also denote
    # a pattern, some command depends on this special characters need to escape
    # slash, like `git reset HEAD\^`, U can also `alias git="noglob git"`, a 3rd
    # option: % noglob git show HEAD^
    setopt EXTENDED_GLOB

    #setopt correctall
    autoload compinstall

	setopt HIST_IGNORE_DUPS
	setopt APPEND_HISTORY
	# When using a hist thing, make a newline show the change before exec it.
	setopt HIST_VERIFY
	setopt HIST_SAVE_NO_DUPS
	setopt HIST_EXPIRE_DUPS_FIRST
	setopt HIST_FIND_NO_DUPS
	setopt SHARE_HISTORY
	setopt INC_APPEND_HISTORY
	setopt HIST_REDUCE_BLANKS
	#为历史纪录中的命令添加时间戳
	setopt EXTENDED_HISTORY
	#在命令前添加空格，不将此命令添加到纪录文件中
	setopt HIST_IGNORE_SPACE

	#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
	setopt AUTO_PUSHD
	#相同的历史路径只保留一个
	setopt PUSHD_IGNORE_DUPS
fi
#}}}

###var(s) for other commands {{{
export EDITOR=vim
export PYTHONSTARTUP=~/.pythonrc
#}}}

# input method {{{
#export XMODIFIER$="@im=ibus"
#export QT_MODULE=ibus
#export GTK_MODULE=ibus
#}}}

# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh