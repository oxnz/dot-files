# Copyright (c) 2014-2021 0xnz. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# ~/.zshrc
#
# Created: 2013-06-25 12:20:00
# Last-update: 2021-06-18 14:32:02
# Version: 0.2
# Author: Oxnz
# Reference: https://github.com/oxnz/dot-files

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

export CLICOLOR=1
export LC_ALL=en_US.UTF-8

PROMPT="%F{cyan}[%F{red}%n%F{green}@%F{blue}%m:%F{magenta}%1~:%F{red}%?%F{cyan}]%#%f "
RPROMPT="%F{cyan}%*%f"

PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
PATH="/Applications/CMake.app/Contents/bin":"$PATH"
PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.8/bin"
export PATH

EDITOR=vim
export EDITOR


#zstyle ':vcs_info:*' enable git
#zstyle ':vcs_info:git*:*' git-revision true
#zstyle ':vcs_info:git*:*' check-for-changes false
#zstyle ':vcs_info:git*' formats "(%s) %12.12i %c%u %b%m"
#zstyle ':vcs_info:git*' actionformats "(%s|%a) %12.12i %c%u %b%m"


zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,%mem,tty,cputime,command'

# Fix upper and lower case
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# correction
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

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
