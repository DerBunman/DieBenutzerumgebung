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

elif [ "$1" = "put" ]; then
	if [ "$2" = "" ]; then
		echo "Error: provide key name"
		echo $help
		exit 1
	fi
	mkdir -p "$STORAGE/${2:h}"
	cat - > "$STORAGE/$2" || exit 1
	exit

else
	echo $help
fi
