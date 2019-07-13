#!/usr/bin/env zsh
which vim.gtk3 && {
	vim.gtk3 -g "$@"
	exit $?
}
which gvim && {
	gvim "$@"
	exit $?
}
