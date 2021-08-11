# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc
# When you login (type username and password) via console,
# either sitting at the machine, or remotely via ssh:
# .profile is executed to configure your shell before the initial command prompt.

# manage PATH variable
pathremove() {
	local IFS=':'
	local rmpath="$1" # path to be removed
	local newpath
	local subpath
	for subpath in $PATH; do
		if [ $subpath != "$rmpath" ]; then
			newpath="${newpath:+$newpath:}$subpath"
		fi
	done
	export PATH="$newpath"
}

pathmunge() {
	case ":${PATH}:" in
		*:"$1":* | "$1:${PATH}:")
			# $1 is already contained or $1 is NIL
			;;
		*)
			if [ "$2" = "after" ]; then
				PATH=$PATH:$1
			else
				PATH=$1:$PATH
			fi
	esac
	export PATH
}

case $(uname -s) in
	Darwin) # macOS Terminal.app run login shell, which read bash_profile instead
		if [ -f ~/.bashrc ]; then
			source ~/.bashrc
		fi
		export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
		pathmunge "$GEM_HOME/bin"
		;;
	Linux)
		test -z "$PROFILEREAD" && . /etc/profile || true
		;;
	*)
		;;
esac



# NOTE: It is recommended to make language settings in ~/.profile rather than
# .bashrc, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.
#
# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
# This overwrites the system default set in /etc/sysconfig/language
# in the variable RC_LANG.
#
# important for language settings, see below.
export LANG=en_US.UTF-8
export LC_CTYPE=$LANG
