# important for language settings, see below.
#
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc
# When you login (type username and password) via console,
# either sitting at the machine, or remotely via ssh:
# .profile is executed to configure your shell before the initial command prompt.

case $(uname -s) in
	Darwin) # macOS Terminal.app run login shell, which read bash_profile instead
		if [ -f ~/.bashrc ]; then
			source ~/.bashrc
		fi
		export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
		export PATH="$GEM_HOME/bin:$PATH"
		;;
	Linux)
		test -z "$PROFILEREAD" && . /etc/profile || true
		;;
	*)
		;;
esac



# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
# This overwrites the system default set in /etc/sysconfig/language
# in the variable RC_LANG.
#
export LANG=en_US.UTF-8
