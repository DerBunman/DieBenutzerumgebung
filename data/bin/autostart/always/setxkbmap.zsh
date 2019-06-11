#!/usr/bin/env zsh
. ${0:A:h}/../../../../lib/config.zsh

tmp=$(mktemp)

conf get setxkbmap/script > "$tmp" || {
	echo "Error: conf is not set up. Please run:"
	echo "dotfiles configure input"
	exit 1
}

. "$tmp"
rm -f "$tmp"
