#!/usr/bin/env zsh
. ${0:h}/../lib/config.zsh

#                                                    _
#   _ __ ___   ___ _ __  _   _ ___    __ _ _ __   __| |
#  | '_ ` _ \ / _ \ '_ \| | | / __|  / _` | '_ \ / _` |
#  | | | | | |  __/ | | | |_| \__ \ | (_| | | | | (_| |
#  |_| |_| |_|\___|_| |_|\__,_|___/  \__,_|_| |_|\__,_|
#       _       __             _ _                _
#    __| | ___ / _| __ _ _   _| | |_  __   ____ _| |_   _  ___  ___
#   / _` |/ _ \ |_ / _` | | | | | __| \ \ / / _` | | | | |/ _ \/ __|
#  | (_| |  __/  _| (_| | |_| | | |_   \ V / (_| | | |_| |  __/\__ \
#   \__,_|\___|_|  \__,_|\__,_|_|\__|   \_/ \__,_|_|\__,_|\___||___/
typeset -a mainmenu_items
mainmenu_items=(
	"features" "Enable/Disable features."
	"behavior" "Change dotfiles manager behavior."
	"input"    "Configure input devices (keyboard)."
	"i18n"     "Language and locale options."
)

# toggleable features
typeset -A features
features=(
	"firefox"   "Prepare firefox profile."
	"dropbox"   "Dropbox client installation."
	"todo-txt"  "todo-txt installation."
	"gtk-theme" "Install the GTK2/3 Theme"
)

# toggleable behaviors
typeset -A behaviors
behaviors=(
	"apt-ask" "Disable to assume yes on all apt commands."
)

# default keyboard configuration
typeset -A setxkmap_defaults
setxkmap_defaults=(
	rules   evdev
	model   evdev
	layout  us
	variant altgr-intl
)

backtitle="DieBenutzerumgebung"

DIALOG_BIN="$(which dialog)"

typeset -A dialog_sizes
dialog_sizes=(
	height 20
	width  80
	rows   10
)

#   _       _ _              _                  _
#  (_)_ __ (_) |_  __      _(_)______ _ _ __ __| |
#  | | '_ \| | __| \ \ /\ / / |_  / _` | '__/ _` |
#  | | | | | | |_   \ V  V /| |/ / (_| | | | (_| |
#  |_|_| |_|_|\__|   \_/\_/ |_/___\__,_|_|  \__,_|
function dialog_init_wizard() {
	# this function will be run when initializing a new system
	# it will setup all necessary config parameters
}

#                   _
#   _ __ ___   __ _(_)_ __    _ __ ___   ___ _ __  _   _
#  | '_ ` _ \ / _` | | '_ \  | '_ ` _ \ / _ \ '_ \| | | |
#  | | | | | | (_| | | | | | | | | | | |  __/ | | | |_| |
#  |_| |_| |_|\__,_|_|_| |_| |_| |_| |_|\___|_| |_|\__,_|
function dialog_mainmenu() {
	local tmp=$(mktemp)
	local text
	read -r -d '' text <<-'EOF'
	Welcome to the DieBenutzerumgebung settings menu.
	Here you can configure how the included tools behave.

	Choose your destiny:
	EOF
	$DIALOG_BIN \
		--backtitle    "$backtitle" \
		--title        "Main Menu" \
		--cancel-label "Exit" \
		--menu         "$text" \
		${dialog_sizes[height]} ${dialog_sizes[width]} ${dialog_sizes[rows]} \
		"${mainmenu_items[@]}" 2> "$tmp"

	local retval=$?

	[ $retval -ne 0 ] && {
		reset
		echo "received non-zero exit code. aborting ..."
		exit
	}

	local choice="$(cat $tmp)"

	# check if dialog choice exists and then run it
	typeset -f dialog_$choice > /dev/null
	if [ $? -eq 0 ]; then
		dialog_$choice
		# return to main menu after submenu finishes
		dialog_mainmenu
	else
		reset
		echo "unknown dialog 'dialog_$choice' called. aborting ..."
		exit 1
	fi
}

#   _                   _
#  (_)_ __  _ __  _   _| |_
#  | | '_ \| '_ \| | | | __|
#  | | | | | |_) | |_| | |_
#  |_|_| |_| .__/ \__,_|\__|
#          |_|
function dialog_input() {
	local tmp=$(mktemp)

	for key value in ${(kv)setxkmap_defaults}; do
		# check if conf is set or set default
		conf get setxkbmap/$key \
			|| echo "$value" | conf put setxkbmap/$key
	done
	
	$DIALOG_BIN \
		--ok-label "Save" \
		--backtitle "$backtitle" \
		--form "Configure keyboard layout for setxkbmap" \
		${dialog_sizes[height]} ${dialog_sizes[width]} ${dialog_sizes[rows]} \
		"Layout:"  1 1 "$(conf get setxkbmap/layout)"  1 10 120 0 \
		"Variant:" 2 1 "$(conf get setxkbmap/variant)" 2 10 120 0 \
		"Rules:"   3 1 "$(conf get setxkbmap/rules)"   3 10 120 0 \
		"Model:"   4 1 "$(conf get setxkbmap/model)"   4 10 120 0 2> "$tmp"

	local retval=$?
	[ $retval -ne 0 ] && {
		dialog_mainmenu
		return
	}

	# this array has to be in the same order as
	# the list passed to dialog
	typeset -A keys
	local keys=(
		1 layout
		2 variant
		3 rules
		4 model
	)
	local i=1
	while read row; do
		echo "$row" | conf put setxkbmap/${keys[$i]}
		i=$((i + 1))
	done < "$tmp"

	# TODO: validate config before saving
}

#    __            _
#   / _| ___  __ _| |_ _   _ _ __ ___  ___
#  | |_ / _ \/ _` | __| | | | '__/ _ \/ __|
#  |  _|  __/ (_| | |_| |_| | | |  __/\__ \
#  |_|  \___|\__,_|\__|\__,_|_|  \___||___/
function dialog_features() {
	local tmp=$(mktemp)
	local active_elements=( $(conf get dotfiles/features_enabled) )

	local text
	read -r -d '' text <<-'EOF'
	This menu allows you to toggle some features of DieBenutzerumgebung.
	EOF

	local list=()
	for feature description in ${(kv)features}; do
		state=off
		if (($active_elements[(Ie)$feature])); then
			state=on
		fi
		
		# auto enable features that weren't known yet
		conf get "dotfiles/features_known/$feature" || {
			state=on
			echo $feature | conf put "dotfiles/features_known/$feature"
			active_elements+=( $feature )
			echo "$active_elements" | conf put dotfiles/features_enabled
		}
		list+=( "$feature" "$description" "$state" )
	done

	$DIALOG_BIN \
		--backtitle "$backtitle" \
		--title     "Toggle features" \
		--checklist "$text" \
			${dialog_sizes[height]} ${dialog_sizes[width]} ${dialog_sizes[rows]} \
			"${list[@]}" 2> $tmp

	local retval=$?

	[ $retval -eq 0 ] \
		&& cat "$tmp" \
		| conf put dotfiles/features_enabled
}

#   _          _                 _
#  | |__   ___| |__   __ ___   _(_) ___  _ __
#  | '_ \ / _ \ '_ \ / _` \ \ / / |/ _ \| '__|
#  | |_) |  __/ | | | (_| |\ V /| | (_) | |
#  |_.__/ \___|_| |_|\__,_| \_/ |_|\___/|_|
function dialog_behavior() {
	local tmp=$(mktemp)
	local active_elements=( $(conf get dotfiles/behaviors_enabled) )

	local text
	read -r -d '' text <<-'EOF'
	This menu allows you to toggle some behaviors of DieBenutzerumgebung.
	EOF

	local list=()
	for behavior description in ${(kv)behaviors}; do
		state=off
		if (($active_elements[(Ie)$behavior])); then
			state=on
		fi
		# auto enable behaviors that weren't known yet
		conf get "dotfiles/behaviors_known/$behavior" || {
			state=on
			echo $behavior | conf put "dotfiles/behaviors_known/$behavior"
			active_elements+=( $behavior )
			echo "$active_elements" | conf put dotfiles/behaviors_enabled
		}
		list+=( "$behavior" "$description" "$state" )
	done

	$DIALOG_BIN \
		--backtitle "$backtitle" \
		--title     "Toggle behaviors" \
		--checklist "$text" \
			${dialog_sizes[height]} ${dialog_sizes[width]} ${dialog_sizes[rows]} \
			"${list[@]}" 2> $tmp

	local retval=$?

	[ $retval -eq 0 ] \
		&& cat "$tmp" \
		| conf put dotfiles/behaviors_enabled
}

# startup
typeset -f dialog_$1 > /dev/null
if [ $? -eq 0 ]; then
	dialog_$1
else
	dialog_mainmenu
fi
