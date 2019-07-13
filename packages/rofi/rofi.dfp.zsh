#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r -i version=1
typeset -r version_upstream="1.5.4"

typeset -r info="$(<<-EOF
	This package builds rofi $version_upstream and installs a deb package from the official git sources.
	EOF
	)"
typeset -r info_short="Rofi $version_upstream from git sources."

typeset -r package_file=$0


typeset -r license="MIT"

typeset -r -a packages_debian=()
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=(
	deb-build-tools
	x11-base
)

typeset -r -a host_flags=(
	has_root
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/bin/rofi_startmenu.zsh "$(path_packages $package)/rofi_startmenu.zsh"
)


update() {
	version_is_already_installed && return
	install "$*"
}

install() {
	install_dependencies_apt
	# build deb is to compile and package debs
	build_deb "$package"
}

tests() {
	validate_symlinks
}

# will be executed after successful install/update
always() {
	install_symlinks
	tests
}
