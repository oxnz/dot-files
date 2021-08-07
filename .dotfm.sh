#!/bin/sh

set -e

GIT=/usr/bin/git
PATH='/bin:/usr/bin'
REPO='git@bitbucket.org:oxnz/dot-files.git'
DEST="$HOME/.config/dot-files.git"

main() {
	GIT_DIR="$HOME/.config/dot-files.git"
	GIT_WORK_TREE="$HOME"
	case "$1" in
		install)
			echo "install"
			if test -e "$DEST"; then
				echo "$DEST already exists" >&2
				exit 1
			fi
			unset GIT_DIR
			if $GIT clone --bare "$REPO" "$DEST"; then
				$GIT config --local status.showUntrackedFiles no
			else
				echo 'clong failed'
				exit 1
			fi
			$GIT switch master
			$GIT checkout .vim
			$GIT checkout .zshrc
			$GIT checkout .bashrc
			$GIT checkout .pythonrc
			$GIT checkout .config/git
			echo 'setup git'
			sh .config/git/bin/config
			;;
		uninst)
			echo "[uninst] not implemented yet" >&2
			;;
		update)
			echo "update"
			exec $GIT --git-dir="$DEST" --work-tree="$HOME" pull
			;;
		*)
			exec $GIT --git-dir="$DEST" --work-tree="$HOME" $@
			;;
	esac
}

main "$@"
