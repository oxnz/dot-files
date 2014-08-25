# .shell > paths

pathmunge() {
	case ":${PATH}:" in
		*:"$1":* | "$1:${PATH}:")
			# $1 is already contained or $1 is NIL
			;;
		*)
			if [ "$2" = "after" ]
			then
				PATH=$PATH:$1
			else
				PATH=$1:$PATH
			fi
	esac
}
# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && pathmunge "$HOME/bin" after
[ -d "/usr/local/jdk/bin" ] && pathmunge "/usr/local/jdk/bin" "after"
[ -d "/opt/jdk/bin" ] && pathmunge "/opt/jdk/bin" "after"
unset pathmunge
