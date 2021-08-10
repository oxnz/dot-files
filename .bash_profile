# .bash_profile is executed for login shells, while .bashrc is executed
# for interactive non-login shells. When you login (type username and password)
# via console, either sitting at the machine, or remotely via ssh:
# .bash_profile is executed to configure your shell before the initial command prompt.

case $(uname -s) in
	Darwin) # macOS Terminal.app run login shell, which read bash_profile instead
		if [ -f ~/.bashrc ]; then
			source ~/.bashrc
		fi
		;;
	*)
		;;
esac
