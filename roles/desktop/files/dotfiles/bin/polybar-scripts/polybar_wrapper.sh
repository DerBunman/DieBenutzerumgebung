#!/usr/bin/env bash
# =====================================
# << THIS FILE IS MANAGED BY ANSIBLE >>
# =====================================
#
# DO NOT EDIT THIS FILE - CHANGES WILL BE OVERWRITTEN
# INSTEAD CHANGE THIS FILE IN THE ANSIBLE REPOSITORY.

killall -q polybar
while pgrep -x polybar >/dev/null; do
	sleep 1
done

for m in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$m polybar --reload i3 &
done
