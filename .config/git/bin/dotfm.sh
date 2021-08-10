#!/bin/sh
#


#config config --local status.showUntrackedFiles no
#echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc

main() {
	set -e
	PATH="/bin:/usr/bin"
	GIT="/usr/bin/git"
	GIT_DIR="$HOME/.config/dot-files.git"
	GIT_WORK_TREE="$HOME"
	case "$1" in
		install)
			echo "install"
			$GIT switch release
			$GIT checkout .vim
			$GIT checkout .zshrc
			$GIT checkout .bashrc
			$GIT checkout .pythonrc
			$GIT checkout .config/git
			sh .config/git/bin/config
			;;
		uninst)
			echo "uninst"
			;;
		update)
			echo "update"
			;;
		*)
			exec /usr/bin/git --git-dir="$HOME/.config/dot-files.git/" --work-tree="$HOME" $@
			;;
	esac
}

main "$@"
