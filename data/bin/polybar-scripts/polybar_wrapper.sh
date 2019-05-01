#!/usr/bin/env bash
killall -q polybar
while pgrep -x polybar >/dev/null; do
	sleep 1
done
set -a
. ~/.config/polybar/local_config.env
set +a

for m in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$m polybar --reload bottom &
done
#polybar bottom
