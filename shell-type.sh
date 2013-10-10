if test -n "$ZSH_VERSION"; then
	PROFILE_SHELL=zsh
elif test -n "$BASH_VERSION"; then
	PROFILE_SHELL=bash
elif test -n "$KSH_VERSION"; then
	PROFILE_SHELL=ksh
elif test -n "$FCEDIT"; then
	PROFILE_SHELL=ksh
elif test -n "$PS3"; then
	PROFILE_SHELL=unknown
else
	PROFILE_SHELL=sh
fi
