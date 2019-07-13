#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This polybar package builds and installs a deb package from the official git sources.
	EOF
	)"

typeset -r info_short="Polybar from git sources."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=()
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=(
	deb-build-tools
	x11-base
	nerdfonts
)

typeset -r -a host_flags=(
	has_root
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/bin/polybar-scripts "$(path_packages $package)/polybar-scripts"
	~/.config/polybar     "$(path_packages $package)/polybar"

)

update() {
	install_symlinks
	#version_is_already_installed && return
	install "$*"
}

install() {
	echo "processing ..."
	install_dependencies_apt
	# build deb is to compile and package debs
	build_deb "$package"
	install_symlinks
}

tests() {
	validate_symlinks
}

# will be executed after successful install/update
always() {
	tests
}
