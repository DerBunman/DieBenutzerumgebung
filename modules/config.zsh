#!/usr/bin/env zsh

STORAGE="$HOME/.config/dotfiles"
test -d "$STORAGE" || mkdir -p "$STORAGE"

help=$({
	echo "Syntax:"
	echo " dotfiles config command some/key"
	echo "Examples:"
	echo " put a key:"
	echo "  echo de_DE | dotfiles config put system/keymap"
	echo " get a key:"
	echo "  dotfiles config get system/keymap"
	echo " edit a key in \$EDITOR (will create if non existant):"
	echo "  dotfiles config edit system/keymap"
})

if [ "$1" = "get" ]; then
	if [ "$2" = "" ]; then
		echo "Error: provide key name"
		echo $help
		exit 1
	fi
	test -f "$STORAGE/$2" || exit 1
	cat "$STORAGE/$2"
	exit
fi

[ -d "$STORAGE/$2" ] && {
	echo "Error: $STORAGE/$2 exists but is a directory."
	exit 1
}

if [ "$1" = "edit" ]; then
	if [ "$2" = "" ]; then
		echo "Error: provide key name"
		echo $help
		exit 1
	fi
	mkdir -p "$STORAGE/${2:h}"
	if ! (( $+commands[$EDITOR] )) ; then
		EDITOR=vim
	fi
	$EDITOR "$STORAGE/$2" || exit 1
	exit
fi


if [ "$1" = "put" ]; then
	if [ "$2" = "" ]; then
		echo "Error: provide key name"
		echo $help
		exit 1
	fi
	mkdir -p "$STORAGE/${2:h}"
	cat - > "$STORAGE/$2" || exit 1
	exit
fi

echo $help
