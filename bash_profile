#!/bin/bash

case $- in
	*i*)	# interactive shell
		;;
	*)	# non-interactive shell
		return
		;;
esac

#PS1='[\u@\h \W]\$ '
PS1="\[\e[0m\][\[\e[1;33m\]\u\[\e[1;31m\]@\h\[\e[1;31m\] \[\e[1;35m\]\W\[\e[1;35m\]\[\e[0m\]]\[\e[1;37m\]$ \[\e[0m\]"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /usr/local/etc/bash_completion ] && ! shopt -oq posix; then
    . /usr/local/etc/bash_completion
fi

for file in ~/.shell/*
do
	if [ -r $file ]; then
		. $file
	fi
done

#shopt -s extglob        # 必须的
#set +o nounset          # 否则某些自动补全将会失败
#
#complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
#complete -A export     printenv
#complete -A variable   export local readonly unset
#complete -A enabled    builtin
#complete -A alias      alias unalias
#complete -A function   function
#complete -A user       su mail finger
#
#complete -A helptopic  help     # 通常与内建命令一样
#complete -A shopt      shopt
#complete -A stopped -P '%' bg
#complete -A job -P '%'     fg jobs disown
#
#complete -A directory  mkdir rmdir
#complete -A directory   -o default cd
#
## 压缩
#complete -f -o default -X '*.+(zip|ZIP)'  zip
#complete -f -o default -X '!*.+(zip|ZIP)' unzip
#complete -f -o default -X '*.+(z|Z)'      compress
#complete -f -o default -X '!*.+(z|Z)'     uncompress
#complete -f -o default -X '*.+(gz|GZ)'    gzip
#complete -f -o default -X '!*.+(gz|GZ)'   gunzip
#complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
#complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
## Postscript,pdf,dvi.....(译者: 打印格式相关)
#complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
#complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
#complete -f -o default -X '!*.pdf' acroread pdf2ps
#complete -f -o default -X '!*.+(pdf|ps)' gv
#complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
#complete -f -o default -X '!*.tex' tex latex slitex
#complete -f -o default -X '!*.lyx' lyx
#complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
## 多媒体
#complete -f -o default -X '!*.+(jp*g|gif|xpm|png|bmp)' xv gimp
#complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
#complete -f -o default -X '!*.+(ogg|OGG)' ogg123
#
#complete -f -o default -X '!*.pl'  perl perl5
