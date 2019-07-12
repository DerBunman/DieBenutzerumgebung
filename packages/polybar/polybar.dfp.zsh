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
	xresources
)

typeset -r -a host_flags=(
	has_root
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/bin/polybar-scripts "${0:h}/polybar-scripts"
	~/.config/polybar     "${0:h}/polybar"

)

tests() {}

update install() {
	echo "processing ..."
	install_dependencies_apt
	# build deb is to compile and package debs
	#build_deb "$package"
	install_symlinks
}
