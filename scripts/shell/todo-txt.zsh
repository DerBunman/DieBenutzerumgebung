#!/usr/bin/env zsh
# DOTFILES_INFO: init:   clones some addons to ~/.todo/actions.d/
# DOTFILES_INFO: update: updates these git repos
# DOTFILES_RUN_ACTIONS:  init

 # todotxt-cli is for ubuntu and todo-txt is for debian
sudo apt-get install todo-txt
sudo apt-get install todotxt-cli

if [ "$1" = "init" ]; then
	mkdir -p ~/.todo/actions.d/
	cd ~/.todo/actions.d/ || exit

	git clone https://github.com/timpulver/todo.txt-graph.git ~/.todo/actions.d/graph
else
	ls ~/.todo/actions.d/ | grep -v .gitkeep --quiet || exit
	for repo in ~/.todo/actions.d/*; do
		cd "${repo}" || continue
		git pull
		cd ..
	done
fi

