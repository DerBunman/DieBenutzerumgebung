#!/usr/bin/env zsh
# DOTFILES_INFO: init:   clones some addons to ~/.todo/actions.d/
# DOTFILES_INFO: update: updates these git repos

if [ "$1" = "init" ]; then
	mkdir -p ~/.todo/actions.d/
	cd ~/.todo/actions.d/ || exit

	git clone https://github.com/timpulver/todo.txt-graph.git ~/.todo/actions.d/graph
else
	test -d ~/.todo/actions.d/ || exit
	for repo in ~/.todo/actions.d/*; do
		cd "${repo}" || continue
		git pull
		cd ..
	done
fi

