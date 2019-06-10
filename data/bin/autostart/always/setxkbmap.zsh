#!/usr/bin/env zsh
. ${0:A:h}/../../../../lib/config.zsh

setxkbmap \
	-rules $(conf get setxkbmap/rules || echo evdev) \
	-model $(conf get setxkbmap/model || echo evdev) \
	-layout $(conf get setxkbmap/layout || echo us) \
	-variant $(conf get setxkbmap/variant || echo altgr-intl)

# todo
#setxkbmap -option 'grp:shift_caps_toggle'
#setxkbmap -option 'caps:swapescape'
