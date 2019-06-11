#!/usr/bin/env zsh

storage_path="$HOME/.config/dotfiles"
test -d "$storage_path" || mkdir -p "$storage_path"

help=$({
	cat <<-'EOF'
	Syntax:
	  conf command some/key
	
	  the key has to be a valid path without leading slash

	Examples:
	  put a key:
	    echo de_DE | dotfiles config put system/keymap
	  get a key:
	    conf get system/keymap
	  edit a key in $EDITOR (will create if non existant):
	    conf edit system/keymap
	EOF

})

if [ "$2" = "" ]; then
	echo "Error: provide key name"
	echo $help
	exit 1
fi

key_path="$storage_path/$2"

[ -d "$key_path" ] && {
	echo "Error: $key_path exists but is a directory."
	exit 1
}

if [ "$1" = "get" ]; then
	test -f "$key_path" || exit 1
	cat "$key_path"
	exit
fi

if [ "$1" = "edit" ]; then
	mkdir -p "${key_path:h}"
	if ! (( $+commands[$EDITOR] )); then
		EDITOR=vim
	fi
	$EDITOR "$key_path" || exit 1
	exit
fi

if [ "$1" = "put" ]; then
	mkdir -p "${key_path:h}"
	cat - > "$key_path" || exit 1
	exit
fi

echo $help