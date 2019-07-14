#!/usr/bin/env zsh
# find ${HOME}/.terminfo /etc/terminfo /lib/terminfo /usr/share/terminfo -iname "${TERM}" 2>/dev/null
[ "$1" = "" ] && {
	echo "Please provide hostname."
	echo "eg:"
	echo "$0 host.com"
	exit 1
}

TERM_FILE="~/.terminfo/${TERM:0:1}/$TERM"
infocmp "$TERM" -I | ssh $1 \
	-o PermitLocalCommand=no "\
	mkdir -pv \"${TERM_FILE:h}\"; \
	test -f \"${TERM_FILE}\" \
	|| cat - > \"${TERM_FILE}\" \
	&& tic \"${TERM_FILE}\""