#!/usr/bin/env zsh
. ${0:h}/../lib/conf.zsh

#   _                      __ _ _             _
#  | |_ _ __ ___  _ __    / _(_) | ___    ___| | ___  __ _ _ __  _   _ _ __
#  | __| '_ ` _ \| '_ \  | |_| | |/ _ \  / __| |/ _ \/ _` | '_ \| | | | '_ \
#  | |_| | | | | | |_) | |  _| | |  __/ | (__| |  __/ (_| | | | | |_| | |_) |
#   \__|_| |_| |_| .__/  |_| |_|_|\___|  \___|_|\___|\__,_|_| |_|\__,_| .__/
#                |_|                                                  |_|
MKTEMP_BIN="$(which mktemp)"
tempfiles="$(mktemp)"
function mktemp() {
	local filename="$($MKTEMP_BIN "${@}")"
	echo "$filename" >> "$tempfiles"
	echo "$filename"
}
function on_exit() {
	test -f "$tempfiles" && {
		#echo "starting on_exit cleanup"
		while read file; do
			#echo removing $file
			test -f "$file" && rm -f "$file"
		done < "$tempfiles"
		#echo "removing $tempfiles (tempfile list)"
		test -f "$tempfiles" && rm -f "$tempfiles"
	}
}
trap on_exit EXIT INT TERM

#       _ _       _
#    __| (_) __ _| | ___   __ _
#   / _` | |/ _` | |/ _ \ / _` |
#  | (_| | | (_| | | (_) | (_| |
#   \__,_|_|\__,_|_|\___/ \__, |
#                         |___/
#             _ _                   _
#    _____  _(_) |_    ___ ___   __| | ___  ___
#   / _ \ \/ / | __|  / __/ _ \ / _` |/ _ \/ __|
#  |  __/>  <| | |_  | (_| (_) | (_| |  __/\__ \
#   \___/_/\_\_|\__|  \___\___/ \__,_|\___||___/
#  
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}


#
## Get the exit status
#return_value=$?
#
## Act on it
#case $return_value in
#  $DIALOG_OK)
#    echo "Result: `cat $tmp_file`";;
#  $DIALOG_CANCEL)
#    echo "Cancel pressed.";;
#  $DIALOG_HELP)
#    echo "Help pressed.";;
#  $DIALOG_EXTRA)
#    echo "Extra button pressed.";;
#  $DIALOG_ITEM_HELP)
#    echo "Item-help button pressed.";;
#  $DIALOG_ESC)
#    if test -s $tmp_file ; then
#      cat $tmp_file
#    else
#      echo "ESC pressed."
#    fi
#    ;;
#esac


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
	"host_flags" "Host specific configs. Eg has root/has x11"
	"features"   "Enable/disable features."
	"behavior"   "Change dotfiles manager behavior."
	"setxkbmap"  "Configure keyboard. (setxkbmap)"
	"desktop"    "i3 and X application specific configuration."
)

desktop_menu_items=(
	"i3-autostart" "Manage i3-autostart entries"
)

# host flags
typeset -A host_flags
host_flags=(
	"has_root"     "User is able to run root cmds via sudo."
	"has_x11"      "Install X11 specific tools too."
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
	"apt-ask"      "Disable to assume yes on all apt commands."
	"xkeys.zsh"    "Run the xkeys.zsh keymapper/keyboard layout daemon."
)

# default keyboard configuration
read -r -d '' setxkbmap_default_script <<'EOF'
setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl
#setxkbmap -option 'grp:shift_caps_toggle'
#setxkbmap -option 'caps:swapescape'
EOF

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
	
	# check if host is not already initialized
	conf get host/initialized && {
		read -r -d '' text <<-'EOF'
		It seems like this host has already been initialized.
		Are you sure that you want to continue?
		EOF
		$DIALOG_BIN \
			--clear \
			--backtitle "$backtitle" \
			--title "Warning" "$@" \
			--yesno "$text" \
			${dialog_sizes[height]} ${dialog_sizes[width]} || {
			echo "Aborted. Have a nice day."
			exit
		}
	}
	# run the following dialogs:
	dialog_host_flags || exit 1
	dialog_behavior || exit 1
	conf_chk_host_flag has_root && echo has_root || echo no_root
	conf_chk_host_flag has_x11 && echo has_x11 || echo no_x11

	# mark homedir as preconfigured and ready for init
	date --iso-8601=seconds | conf put host/preconfigured
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
		--help-button \
		--cancel-label "Exit" \
		--ok-label     "Select" \
		--menu         "$text" \
		${dialog_sizes[height]} ${dialog_sizes[width]} ${dialog_sizes[rows]} \
		"${mainmenu_items[@]}" 2> "$tmp"

	# Get the exit status
	local return_value=$?
	local choice="$(cat "$tmp")"

	# Act on it
	case $return_value in
		$DIALOG_HELP)
			echo "Help pressed."
			echo choice $choice
			echo "No help for you. Also good bye!"
			exit
			;;
		$DIALOG_CANCEL)
			echo "Exit button activated. Have a nice day."
			exit
			;;
		$DIALOG_ESC)
			echo "ESC pressed. Have a nice day."
			exit
			;;
	esac

	# check if dialog choice exists and then run it
	typeset -f dialog_$choice > /dev/null
	if [ $? -eq 0 ]; then
		dialog_$choice
		# return to main menu after submenu finishes
		dialog_mainmenu
	else
		echo "unknown dialog 'dialog_$choice' called. aborting ..."
		exit 1
	fi
}

#            _        _    _
#   ___  ___| |___  _| | _| |__  _ __ ___   __ _ _ __
#  / __|/ _ \ __\ \/ / |/ / '_ \| '_ ` _ \ / _` | '_ \
#  \__ \  __/ |_ >  <|   <| |_) | | | | | | (_| | |_) |
#  |___/\___|\__/_/\_\_|\_\_.__/|_| |_| |_|\__,_| .__/
#                                               |_|
function dialog_setxkbmap() {
	local tmp=$(mktemp)
	local tmp_text=$(mktemp)
	local tmp_setxkbmap_script=$(mktemp)

	cat > "$tmp_text" <<-'EOF'
	The following dialog will spawn a editor
	where you can put setxkbmap commands.
	Technically you could put any commands in there
	as it is parsed by zsh on i3 startup.
	EOF
	$DIALOG_BIN \
		--exit-label "Ok" \
		--title "Keyboard setxkbmap script" \
		--backtitle "$backtitle" \
		--textbox "$tmp_text" \
		${dialog_sizes[height]} ${dialog_sizes[width]}

	# check if conf is set or put default
	conf get setxkbmap/script \
		|| echo "$setxkbmap_default_script" | conf put setxkbmap/script

	conf get setxkbmap/script > "$tmp_setxkbmap_script"

	$DIALOG_BIN \
		--ok-label "Save" \
		--title "Keyboard setxkbmap script" \
		--backtitle "$backtitle" \
		--editbox "$tmp_setxkbmap_script" \
		${dialog_sizes[height]} ${dialog_sizes[width]} 2> "$tmp"

	local retval=$?
	[ $retval -ne 0 ] && {
		return
	}

	local tmp_check=$(mktemp)
	# save config after successful run
	. "$tmp" 2> "$tmp_check" 1>&2 && {
		cat "$tmp" | conf put setxkbmap/script
		# TODO success message
		return
	}

	local tmp_text=$(mktemp)
	
	cat > "$tmp_text" <<-'EOF'
	There was an error running your setxbmap script.
	The script has not been saved.

	EOF
	cat "$tmp_check" >> "$tmp_text"

	$DIALOG_BIN \
		--clear \
		--backtitle "$backtitle" \
		--title "Error" "$@" \
		--exit-label "OK" \
		--textbox "$tmp_text" \
		${dialog_sizes[height]} ${dialog_sizes[width]}

	#TODO let user edit his failed script until ok or cancel

}

#   _               _        __ _
#  | |__   ___  ___| |_     / _| | __ _  __ _ ___
#  | '_ \ / _ \/ __| __|   | |_| |/ _` |/ _` / __|
#  | | | | (_) \__ \ |_    |  _| | (_| | (_| \__ \
#  |_| |_|\___/|___/\__|___|_| |_|\__,_|\__, |___/
#                     |_____|           |___/
function dialog_host_flags() {
	local tmp=$(mktemp)
	local active_elements=( $(conf get dotfiles/host_flags_enabled) )

	local text
	read -r -d '' text <<-'EOF'
	This menu allows you to toggle some host_flags of DieBenutzerumgebung.
	EOF

	local list=()
	for host_flag description in ${(kv)host_flags}; do
		state=off
		if (($active_elements[(Ie)$host_flag])); then
			state=on
		fi
		
		# auto enable host_flags that weren't known yet
		conf get "dotfiles/host_flags_known/$host_flag" || {
			state=on
			echo $host_flag | conf put "dotfiles/host_flags_known/$host_flag"
			active_elements+=( $host_flag )
			echo "$active_elements" | conf put dotfiles/host_flags_enabled
		}
		list+=( "$host_flag" "$description" "$state" )
	done

	$DIALOG_BIN \
		--backtitle "$backtitle" \
		--title     "Toggle host_flags" \
		--checklist "$text" \
			${dialog_sizes[height]} ${dialog_sizes[width]} ${dialog_sizes[rows]} \
			"${list[@]}" 2> $tmp

	local return_value=$?

	# Act on it
	case $return_value in
		$DIALOG_OK)
			cat "$tmp" | conf put dotfiles/host_flags_enabled
			return 0
			;;
		$DIALOG_ESC | $DIALOG_CANCEL)
			echo "Exit button activated. Have a nice day."
			return 1
			;;
	esac

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
