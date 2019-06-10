#!/usr/bin/env zsh

typeset -a mainmenu_items
mainmenu_items=(
	"features" "Enable/Disable features."
	"i18n"     "Language and locale options."
)

# toggleable features
typeset -A features
features=(
	"dropbox"  "Dropbox client installation."
	"todo-txt" "todo-txt installation."
)

function dialog_mainmenu() {
	tmp=$(mktemp)
	dialog \
		--backtitle "DieBenutzerumgebung" \
		--title "Main Menu" \
		--cancel-label "Exit" \
		--menu "This is the dialog based configuraion interface.\nPlease choose a submenu:" \
		20 61 10 \
		"${mainmenu_items[@]}" 2> $tmp

	retval=$?

	[ $retval -ne 0 ] && {
		echo "received non-zero exit code. aborting ..."
		exit
	}

	choice="$(cat $tmp)"
	
	typeset -f dialog_$choice
	if [ $? -eq 0 ]; then
		dialog_$choice
	else
		echo "unknown dialog 'dialog_$choice' called. aborting ..."
		exit 1
	fi
}


function dialog_features() {
	tmp=$(mktemp)
	active_elements=( $(./dotfiles config get dialog/dotfiles/features) )

	list=()
	for feature description in ${(kv)features}; do
		state=off
		if (($active_elements[(Ie)$feature])); then
			state=on
		fi
		list+=( "$feature" "$description" "$state" )
	done

	dialog \
		--backtitle "DieBenutzerumgebung" \
		--title     "Toggle features" \
		--checklist "This menu allows you to toggle some features \
			of DieBenutzerumgebung." 20 61 10 \
			"${list[@]}" 2> $tmp

	retval=$?

	[ $retval -eq 0 ] \
		&& cat $tmp \
		| ./dotfiles config put dialog/dotfiles/features

	dialog_mainmenu
}

typeset -f dialog_$1
if [ $? -eq 0 ]; then
	dialog_$1
else
	dialog_mainmenu
fi
