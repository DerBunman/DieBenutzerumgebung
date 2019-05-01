#!/usr/bin/env zsh
# DOTFILES_INFO: installs and updates vim plugins
# DOTFILES_RUN_ACTIONS: init, update
# DOTFILES_FORCE_RUN
if [ "${1}" = "init" ]; then
	vim +PlugInstall +qall -u ~/.vim/vimrc_plug.vim
else
	vim +PlugClean +qall -u ~/.vim/vimrc_plug.vim
	vim +PlugInstall +qall -u ~/.vim/vimrc_plug.vim
	vim +PlugUpdate +qall -u ~/.vim/vimrc_plug.vim
fi
