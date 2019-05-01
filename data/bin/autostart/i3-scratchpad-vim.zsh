#!/usr/bin/env zsh
gvim "$@"
i3-msg '[instance=gvim] mark vimscratch, move scratchpad'
