#!/usr/bin/env zsh
function conf() {
	$HOME/.repos/dotfiles/modules/conf.zsh "$@"
}


function conf_chk_behavior() {
	local behaviors_enabled=( $(conf get dotfiles/behaviors_enabled) )
	[ "${behaviors_enabled[(r)$1]}" = "$1" ] && return 0 || return 1
}

function conf_chk_feature() {
	local features_enabled=( $(conf get dotfiles/features_enabled) )
	[ "${features_enabled[(r)$1]}" = "$1" ] && return 0 || return 1
}

function conf_chk_host_flag() {
	local host_flags_enabled=( $(conf get dotfiles/host_flags_enabled) )
	[ "${host_flags_enabled[(r)$1]}" = "$1" ] && return 0 || return 1
}

function conf_chk_dfp_installed() {
	local installed=( $(conf get dfp/installed) )
	[ "${installed[(r)$1]}" = "$1" ] && return 0 || return 1
}
