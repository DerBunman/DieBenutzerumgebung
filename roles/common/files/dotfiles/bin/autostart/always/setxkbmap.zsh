#!/usr/bin/env zsh
. ${0:A:h}/../../../../lib/conf.zsh

tmp=$(mktemp)
trap "rm -f \"$tmp\"" EXIT INT TERM

conf get setxkbmap/script > "$tmp" || {
	echo "Error: conf is not set up. Please run:"
	echo "dotfiles configure input"
	exit 1
}
. "$tmp"
