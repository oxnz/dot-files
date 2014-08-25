# ~/.bash_profile

# If not running interactively, don't do anything
case $- in
	*i*) ;;		# interactive shell
	*) return;;	# non-interactive shell
esac

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
