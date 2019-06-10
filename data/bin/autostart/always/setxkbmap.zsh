#!/usr/bin/env zsh
. ${0:A:h}/../../../../lib/config.zsh

trap on_error ERR
function on_error() {
	echo -e "\n\nThe failed commandline:"
	echo         "======================"
	echo "setxkbmap $args"

	exit 1
}

args=(
	-rules $(conf get setxkbmap/rules || echo evdev)
	-model $(conf get setxkbmap/model || echo evdev)
	-layout $(conf get setxkbmap/layout || echo us)
	-variant $(conf get setxkbmap/variant || echo altgr-intl)
)
setxkbmap "${args[@]}"

# todo
#setxkbmap -option 'grp:shift_caps_toggle'
#setxkbmap -option 'caps:swapescape'
