# ~/.shell/functions.zsh

# set terminal title
case $TERM in
	(*xterm|*rxvt*|(dt|k|E)term)
		function precmd() {
			print -Pn "\e]0;%n@%M:%/\a"
		}
		function preexec() {
			print -Pn "\e]0;%n@%M:%/\:$1\a"
		}
		;;
esac
