#!/usr/bin/env zsh
debug=${debug:-false}

# load needed libs
# bzcurses is loaded later on
. ${0:h}/../lib/conf.zsh



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
Welcome to the DieBenutzerumgebung menuconfig.
Feel free to play around.
EOF
)}"

# main menu choices
typeset -A main_choices=(
	host_flags   "01. Set dotfiles flags for this host."
	features     "02. Toggle dotfiles managed features."
	save_apply   "XX. Leave this menu and save the current settings."
)
typeset -A main_choice_actions=(
	host_flags  "function::_draw_checkboxes::host_flags"
	features    "function::_draw_checkboxes::features"
	save_apply  "function::dotfiles_main_menu_save"
)
#main_choice_order=( ${(onk)main_choices[@]} )
main_choice_order=( host_flags save_apply )

# will be displayed on startup if there is new stuff
new_stuff_text="$(<<EOF
Either this is a new installation, or there is new stuff.
Make sure to check everything out, because new features and flags are enabled by default.
 
There are the new features I found and enabled. (But not saved.)
Please deactivate not wanted host_flags.
 
 
EOF
)"$'\n'


#    __            _
#   / _| ___  __ _| |_ _   _ _ __ ___  ___
#  | |_ / _ \/ _` | __| | | | '__/ _ \/ __|
#  |  _|  __/ (_| | |_| |_| | | |  __/\__ \
#  |_|  \___|\__,_|\__|\__,_|_|  \___||___/
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

host_flags_checkboxes_checked=( "$(conf get "dotfiles2/host_flags/checked")" )

for feature (${(k)host_flags_checkboxes}) {
	conf get "dotfiles2/host_flags/known/$feature" || {
		new_stuff_text+="New feature: ${host_flags_checkboxes[$feature]}"$'\n'
			host_flags_checkboxes_checked+=( "$feature" )
	}
}

typeset -A new_stuff_textbox_buttons=(
    ok "DISMISS"
)
typeset -a new_stuff_textbox_buttons_order=(
    ok
)



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

	[ ${#new_stuff_text} -gt 0 ] && {
		_draw_textbox "new_stuff" "New Stuff" "${new_stuff_text}"
	}

	# draw the choices window from the main choices
	_draw_choices main

} "${0:h}/../lib/bzcurses/bzcurses.zsh"

echo yo yo yo
