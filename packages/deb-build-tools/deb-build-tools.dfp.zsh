#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package installs the essentials for building deb-Packages.
	EOF
	)"

typeset -r info_short="Debian deb build tools."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=(
	moreutils
	build-essential
	fakeroot
	devscripts
	dpkg-dev
	equivs
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=()

typeset -r -a host_flags=(
	has_root
)

# these symlinks will be created
typeset -r -A symlinks=()

tests() {}

update install() {
	install_dependencies_apt
}
