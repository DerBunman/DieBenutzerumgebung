#!/usr/bin/env zsh
# inspiration:
# https://www.reddit.com/r/i3wm/comments/bp02f8/howto_tint_the_whole_screen_red_when_you_enter_a/
# by /u/tasinet

if [[ "$@" = "red" ]]; then
	GAMMA=4:2:2
elif [[ "$@" = "green" ]]; then
	GAMMA=1.2:2:1.2
elif [[ "$@" = "blue" ]]; then
	GAMMA=1.2:1.2:2
elif [[ "$@" = "grey" ]]; then
	GAMMA=2:2:2
elif [[ "$@" = "test" ]]; then
	GAMMA=4:2:2
elif [[ "$@" = "off" ]]; then
	GAMMA=1:1:1
else
	echo Requires one of: "red", "off"
	exit 128
fi

for output in $(xrandr --prop | grep \ connected | cut -d\  -f1); do
	xrandr --output $output --gamma $GAMMA
done
