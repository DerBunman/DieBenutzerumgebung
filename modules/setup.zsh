#!/usr/bin/env zsh
debug=${debug:-false}

# load needed libs
# bzcurses is loaded later on
. ${0:h}/../lib/conf.zsh
. ${0:h}/../lib/path.helpers.zsh
. ${0:h}/../lib/text.helpers.zsh
. ${0:h}/../lib/dfp.tools.zsh

# TODO: cleanup code structure


title_stdscr="DieBenutzerumgebung"

# set default theme or from env variable
# for example, start this script like this
# $ theme=nerdfonts ./example.zsh
theme=${theme:-default}



#                   _
#   _ __ ___   __ _(_)_ __    _ __ ___   ___ _ __  _   _
#  | '_ ` _ \ / _` | | '_ \  | '_ ` _ \ / _ \ '_ \| | | |
#  | | | | | | (_| | | | | | | | | | | |  __/ | | | |_| |
#  |_| |_| |_|\__,_|_|_| |_| |_| |_| |_|\___|_| |_|\__,_|
main_choices_title="Main Menu"

# main menu intro text (max 4 rows)
main_choices_intro_text="${$(cat <<EOF
Welcome to the DieBenutzerumgebung setup.
EOF
)}"

# main menu choices
typeset -A main_choices=(
	host_flags   "Set host_flags. These flags define we can do."
	#save_apply   "XX. Leave this menu and save the current settings."
)
typeset -A main_choice_actions=(
	host_flags  "function::_draw_checkboxes::host_flags"
	setxkbmap   "function::edit_setxkbmap"
	choose_dfps "function::choose_dfps"
	#save_apply  "function::dotfiles_main_menu_save"
)
main_choice_order=( host_flags )


#            _ _ _              _        _    _
#    ___  __| (_) |_   ___  ___| |___  _| | _| |__  _ __ ___   __ _ _ __
#   / _ \/ _` | | __| / __|/ _ \ __\ \/ / |/ / '_ \| '_ ` _ \ / _` | '_ \
#  |  __/ (_| | | |_  \__ \  __/ |_ >  <|   <| |_) | | | | | | (_| | |_) |
#   \___|\__,_|_|\__| |___/\___|\__/_/\_\_|\_\_.__/|_| |_| |_|\__,_| .__/
#                                                                  |_|
edit_setxkbmap() {
	# set default value if there was no conf value
	conf get setxkbmap/script > /dev/null || {
		cat <<-EOF | conf put setxkbmap/script
		setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl
		setxkbmap -option 'grp:shift_caps_toggle'
		setxkbmap -option 'caps:swapescape'
		EOF
	}

	_draw_textbox setxkbmap "setxkbmap" "$(<<-EOF
	A text editor will spawn after closing this dialog.
	Please setup keyboard configuration in this editor.
	 
	If you don't know what setxkbmap expects, you can enter the following:
	setxkbmap us
	 
	Or to get a german layout:
	setxkbmap de
	
	EOF
	)"

	# open an editor with the setxkbmap script
	_run_editor "$HOME/.config/dotfiles/setxkbmap/script"

}

#        _                                 _  __
#    ___| |__   ___   ___  ___  ___     __| |/ _|_ __  ___
#   / __| '_ \ / _ \ / _ \/ __|/ _ \   / _` | |_| '_ \/ __|
#  | (__| | | | (_) | (_) \__ \  __/  | (_| |  _| |_) \__ \
#   \___|_| |_|\___/ \___/|___/\___|___\__,_|_| | .__/|___/
#                                 |_____|       |_|
typeset -a forced_dfps=()
choose_dfps() {
	generate_packages_array

	local newline=" "$'\n'

	local text="$(text_figlet "DFP analyzer")$newline"

	local disabled_text="$(text_underlined "disabled DFPs:")$newline"

	local dfp_pb=$(path_dfp_pb)
	local available_dfps=()

	for package in ${(k)packages}; do
		local needed_flags=( $($dfp_pb $package dependencies host_flags) )
		for needed_flag in $needed_flags; do
			# skip package if there is a host flag missing
			conf_chk_host_flag $needed_flag || {
				disabled_text+="  - $package because $needed_flag is not set.$newline"
				continue 2
			}
		done

		[ "$($dfp_pb $package base_package)" = true ] && {
			forced_dfps+=( $package )
			continue
		}

		available_dfps+=( $package )
	done
	
	# disabled DFPs
	text+="${newline}${disabled_text} $newline"

	# forced DFPs
	text+="$(text_underlined "Forced base DFPs (these can not be disabled)")$newline"
	for dfp in $forced_dfps; do
		text+="  - ${dfp}${newline}"
	done

	error=false

	# available DFPs
	text+="$newline$(text_underlined "Available DFPs")${newline}"
	text+="rd = recursive dependencies${newline} ${newline}"

	for dfp in $available_dfps; do
		rdepends=( $($dfp_pb $dfp dfp_rdepenends) )
		for dep in ${rdepends[@]}; do
			[[ "${available_dfps[(r)$dep]}" = "" && "${forced_dfps[(r)$dep]}" = "" ]] && {
				error=true
				text+="  ERROR: $dfp rdepends on $dep, but $dep is disabled.$newline"
				# remove dfp from available_dfps
				available_dfps[$available_dfps[(i)$dfp]]=()
			}
		done
		text+="  - ${dfp} (rd: ${${rdepends// /$newline        }:-none}) ${newline}"
	done

	[ $error = true ] && {
		text+=" ${newline}$(text_underlined "There where errors. Remaining DFPs")${newline} ${newline}$available_dfps"
	}

	_draw_textbox available_dfps "Available DFPs" "$text"

	choose_dfps_checkboxes=()
	choose_dfps_checkbox_order=()
	for dfp in ${available_dfps[@]}; do
		choose_dfps_checkboxes+=( $dfp "$dfp: $($dfp_pb $dfp info_short)" )
		choose_dfps_checkbox_order+=( $dfp )
	done

	_draw_checkboxes choose_dfps
}

#        _                                 _  __
#    ___| |__   ___   ___  ___  ___     __| |/ _|_ __  ___
#   / __| '_ \ / _ \ / _ \/ __|/ _ \   / _` | |_| '_ \/ __|
#  | (__| | | | (_) | (_) \__ \  __/  | (_| |  _| |_) \__ \
#   \___|_| |_|\___/ \___/|___/\___|___\__,_|_| | .__/|___/
#                                 |_____|       |_|
#        _               _    _
#    ___| |__   ___  ___| | _| |__   _____  _____  ___
#   / __| '_ \ / _ \/ __| |/ / '_ \ / _ \ \/ / _ \/ __|
#  | (__| | | |  __/ (__|   <| |_) | (_) >  <  __/\__ \
#   \___|_| |_|\___|\___|_|\_\_.__/ \___/_/\_\___||___/
choose_dfps_checkboxes_intro_text="$(<<EOF
Toggle DFPs to install.
EOF
)"
choose_dfps_checkboxes_title="choose_dfps"

typeset -A choose_dfps_checkboxes=()
choose_dfps_checkbox_order=()

choose_dfps_checkboxes_checked=()

typeset -A choose_dfps_checkboxes_buttons=(
	install "INSTALL"
	ok      "BACK"
	exit    "ABORT"
)
choose_dfps_checkboxes_buttons_order=( "install" "ok" "exit" )
choose_dfps_checkboxes_buttons_active=1

#                    __ _                    _           _        _ _
#    ___ ___  _ __  / _(_)_ __ _ __ ___     (_)_ __  ___| |_ __ _| | |
#   / __/ _ \| '_ \| |_| | '__| '_ ` _ \    | | '_ \/ __| __/ _` | | |
#  | (_| (_) | | | |  _| | |  | | | | | |   | | | | \__ \ || (_| | | |
#   \___\___/|_| |_|_| |_|_|  |_| |_| |_|___|_|_| |_|___/\__\__,_|_|_|
#                                      |_____|
typeset -A confirm_install_textbox_buttons=(
	ok      "CHANGE SELECTION"
	install "INSTALL"
	exit    "ABORT"
)
confirm_install_textbox_buttons_order=( "ok" "install" "exit" )
confirm_install_textbox_buttons_active=1

confirm_install_textbox_buttons_actions.install() {
	zcurses end
	reset
	#                     __                        _           _        _ _
	#    _ __   ___ _ __ / _| ___  _ __ _ __ ___   (_)_ __  ___| |_ __ _| | |
	#   | '_ \ / _ \ '__| |_ / _ \| '__| '_ ` _ \  | | '_ \/ __| __/ _` | | |
	#   | |_) |  __/ |  |  _| (_) | |  | | | | | | | | | | \__ \ || (_| | | |
	#   | .__/ \___|_|  |_|  \___/|_|  |_| |_| |_| |_|_| |_|___/\__\__,_|_|_|
	#   |_|
	for dfp in ${forced_dfps[@]}; do
		"$(path_root)/modules/dfp.zsh" install $dfp
	done
	for dfp in ${choose_dfps_checkboxes_checked[@]}; do
		"$(path_root)/modules/dfp.zsh" install $dfp
	done
	exit
}

#        _                                 _  __
#    ___| |__   ___   ___  ___  ___     __| |/ _|_ __  ___
#   / __| '_ \ / _ \ / _ \/ __|/ _ \   / _` | |_| '_ \/ __|
#  | (__| | | | (_) | (_) \__ \  __/  | (_| |  _| |_) \__ \
#   \___|_| |_|\___/ \___/|___/\___|___\__,_|_| | .__/|___/
#                                 |_____|       |_|
#   _           _        _ _
#  (_)_ __  ___| |_ __ _| | |
#  | | '_ \/ __| __/ _` | | |
#  | | | | \__ \ || (_| | | |
#  |_|_| |_|___/\__\__,_|_|_|
choose_dfps_checkboxes_buttons_actions.install() {
	local newline=" "$'\n'
	local text="$(text_underlined "The following packages will be installed:")$newline"
	text+="Forced: ${forced_dfps}${newline}"
	text+="User selection: ${choose_dfps_checkboxes_checked}"

	_draw_textbox confirm_install "Confirm package install" "$text"
}


#   _               _        __ _
#  | |__   ___  ___| |_     / _| | __ _  __ _ ___
#  | '_ \ / _ \/ __| __|   | |_| |/ _` |/ _` / __|
#  | | | | (_) \__ \ |_    |  _| | (_| | (_| \__ \
#  |_| |_|\___/|___/\__|___|_| |_|\__,_|\__, |___/
#                     |_____|           |___/
host_flags_checkboxes_intro_text="$(<<EOF
Toggle host_flags.
EOF
)"
host_flags_checkboxes_title="host_flags"

typeset -A host_flags_checkboxes=(
	has_x11          "X11 is available and should be used."
	has_root         "Root via sudo is available."
	install_packages "Install APT packages."
	assume_yes       "Assume yes for all questions. (update only)"
)
host_flags_checkbox_order=(
	has_x11
	has_root
	install_packages
	assume_yes
)

host_flags_checkboxes_checked=( $(conf get "dotfiles/host_flags/checked") )


typeset -A host_flags_checkboxes_buttons=(
	save "SAVE"
	exit "ABORT"
)
host_flags_checkboxes_buttons_order=( "save" "exit" )
host_flags_checkboxes_buttons_active=1

#   _               _        __ _
#  | |__   ___  ___| |_     / _| | __ _  __ _ ___   ___  __ ___   _____
#  | '_ \ / _ \/ __| __|   | |_| |/ _` |/ _` / __| / __|/ _` \ \ / / _ \
#  | | | | (_) \__ \ |_    |  _| | (_| | (_| \__ \ \__ \ (_| |\ V /  __/
#  |_| |_|\___/|___/\__|___|_| |_|\__,_|\__, |___/ |___/\__,_| \_/ \___|
#                     |_____|           |___/
host_flags_checkboxes_buttons_actions.save() {
	echo $host_flags_checkboxes_checked | conf put "dotfiles/host_flags/checked"
	_draw_textbox host_flags_saved "Host_flags saved" "Your host_flags settings have been saved."

	# If the user selected has_x11 then open setxkbmap dialog
	[ "${host_flags_checkboxes_checked[(r)has_x11]}" = "has_x11" ] && {
		# add setxkbmap to main choices dialog
		[ "${main_choices[setxkbmap]}" = "" ] && {
			# add new setxkbmap choice
			main_choices+=(
				setxkbmap "Setup keyboard using setxkbmap."
			)
			main_choice_order+=( setxkbmap )

			# highlight next setxkbmap action
			main_choice_active=$(( $main_choice_active +1 ))

			# run the editor
			edit_setxkbmap
		}
	}

	# add choose_dfps to main choices
	[ "${main_choices[choose_dfps]}" = "" ] && {
		# add new dfp selector choice
		main_choices+=(
			choose_dfps "Select packages to install."
		)
		main_choice_order+=( choose_dfps )

		# highlight next setxkbmap action
		main_choice_active=$(( $main_choice_active +1 ))
	}

	_draw_choices main
	return 100
}




dotfiles_main_menu_save() {
	local text="$(<<-EOF
	Please check your configuration:
	 
	Active host_flags:
	----------------
	 - Shell/CLI host_flags. (required)
	EOF
	)"

	for id (${(k)host_flags_checkboxes_checked}) text+=$'\n'" - ${host_flags_checkboxes[$id]}"

	_draw_textbox "save_apply" "Save and apply" "${text}"
}


#--- END OF CONFIGURATION ---#

# wrapped in an anonymous function so we don't
# pollute the rest of the script with our traps and stuff
function() {
	# include and initialize bzcurses
	. "$1"

	# draw the choices window from the main choices
	_draw_choices main

} "${0:h}/../lib/bzcurses/bzcurses.zsh"

echo yo yo yo
