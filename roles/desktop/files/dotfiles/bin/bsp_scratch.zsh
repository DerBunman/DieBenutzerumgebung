#!/usr/bin/env zsh
SCRATCHPAD="${1:-scratchpad_gvim}"
#echo "Toggling: ${SCRATCHPAD}"
typeset -a ids=( ${=${(f)$(xdotool search --class $SCRATCHPAD)}} )

if [ "$ids" != "" ]; then
	for id in $ids; do
		bspc node "$id" --flag hidden -f || continue
	done
fi
