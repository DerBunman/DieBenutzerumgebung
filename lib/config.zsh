#!/usr/bin/env zsh
function conf() {
	$HOME/.repos/dotfiles/modules/conf.zsh "$@"
}


function conf_chk_behavior() {
	local behaviors_enabled=( $(conf get dotfiles/behaviors_enabled) )
	[ "${behaviors_enabled[(r)$1]}" = "$1" ] && return 0 || return 1
}

