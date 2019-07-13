#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package installs vim and my config.
	When the host_flag has_x11 is enabled it also installs gvim.
	EOF
	)"

typeset -r info_short="VIM and its config."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

# when has_x11 is active add vim-gtk3
local additional_packages=()
conf_chk_host_flag has_x11 \
	&& additional_packages+=( vim-gtk3 )

typeset -r -a packages_debian=(
	vim
	exuberant-ctags
	$additional_packages[@]
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=( )

typeset -r -a host_flags=(
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/.vim     "$(path_packages $package)/vim"
	~/bin/gvim "$(path_packages $package)/gvim.zsh"
)

tests() {
	validate_symlinks
}

# the update/install function only creates a symlink.
# for this package
update() {
	install_dependencies_apt
	install_symlinks
	vim +PlugClean +qall -u ~/.vim/vimrc_plug.vim
	vim +PlugInstall +qall -u ~/.vim/vimrc_plug.vim
	vim +PlugUpdate +qall -u ~/.vim/vimrc_plug.vim
}

install() {
	install_dependencies_apt
	install_symlinks
	vim +PlugInstall +qall -u ~/.vim/vimrc_plug.vim
}

always() {
	tests
}
