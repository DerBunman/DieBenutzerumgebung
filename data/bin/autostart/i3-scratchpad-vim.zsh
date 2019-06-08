#!/usr/bin/env zsh
gvim --class scratchpad_gvim "$@"
sleep 1
i3-msg '[class=scratchpad_gvim] mark mainscratch, move scratchpad'
