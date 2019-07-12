#!/usr/bin/env zsh
test -d "$HOME/bin" || mkdir "$HOME/bin/"
test -e "$HOME/bin/conf" || ln -s "${0:A:h:h}/modules/conf.zsh" $HOME/bin/conf

function conf() {
	$HOME/.repos/dotfiles/modules/conf.zsh "$@"
}

#alias conf="$HOME/.repos/dotfiles/modules/conf.zsh"

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
	conf get dfp/installed/$1/version >/dev/null || return 1
	return 0
}
