# Switches for shell control

export CLICOLOR=1
export LC_ALL=en_US.UTF-8

HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd..:cd.."
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
#HISTFILE="$HOME/.sh_history"
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=100000
HISTSIZE=10000
# for tcsh
SAVEHIST=$HISTSIZE

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
# vim: ts=4 sw=4 et filetype=sh
