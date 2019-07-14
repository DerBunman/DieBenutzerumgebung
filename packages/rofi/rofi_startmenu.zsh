#!/usr/bin/env zsh
self="$0"
if [[ "$#" -eq 0 ]]; then
	#drun_icon='\uf013' # Gear
	run_icon=$(echo '\uf013') # Gear
	rofi \
			-pid ~/.rofi.menu.pid \
			-i \
			-show-icons \
			-location 7 \
			-yoffset -30 \
			-width 520 \
			-no-sidebar-mode \
			-no-lazy-grab \
			-display-run "$run_icon cmd" \
			-display-drun "all apps" \
			-kb-mode-next "Control+Alt+space" \
			-run-command "{cmd}" \
			-drun-match-fields "categories,name" \
			-show mymenu \
			-modi mymenu:"$0 show",drun
	exit
fi
echo "$*" $X 1>&2
shift

if [ "$1" = "quit" ]; then
    exit 0
fi

categories=$(grep Categories \
	/usr/share/applications/*.desktop \
	~/.local/share/applications/*desktop \
	| cut -d'=' -f2 \
	| sed 's/;/\n/g' \
	| grep -v "^$\|^X-" \
	| sed 's/^/» /g' \
	| LC_COLLATE=POSIX sort --ignore-case --unique)

if [ "$1" = "Application Categories" ]; then
	echo -en "\x00prompt\x1f$1\n"
	echo "back"
	echo "${categories}"
	echo "quit"

elif [ "${1}" = "Show i3 keymap" ]; then
	{
		i3keys web 8080 & 
		sleep 3 && $BROWSER http://localhost:8080
	} &
	killall rofi

elif [ "${1[1]}" = "»" ]; then
	xdotool search --class rofi key --delay 0 --clearmodifiers 'Control+Alt+space'
	xdotool search --class rofi type --delay 1 "${1:2}"

	echo "swag"

else
	icon='\uf015' # Home
	echo -en "\x00prompt\x1f$icon main menu\n"
	#echo -en "\0urgent\x1f0,2\n"
	echo -en "\0active\x1f1\n"
	echo -en "\0markup-rows\x1ftrue\n"
	echo -en "\0message\x1fSpecial <b>bold</b> message\n"

	echo -en "Application Categories\0icon\x1ffolder\n"
	echo -en "Show i3 keymap\0icon\x1ffolder\n"
	
fi