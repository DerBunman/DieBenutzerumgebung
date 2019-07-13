#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package contains xdg-utils and mimetypes.
	EOF
	)"

typeset -r info_short="xdg-utils and mimetypes."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=( xdg-utils )
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=( )
typeset -r -a host_flags=()

# these symlinks will be created
typeset -r -A symlinks=(
	# depreacted mimetype paths for old apps
	~/.config/mimeapps.list                   "$(path_packages $package)/mimeapps.list"
	~/.local/share/applications/mimeapps.list "$(path_packages $package)/mimeapps.list"
	~/.local/share/applications/defaults.list "$(path_packages $package)/mimeapps.list"

	# desktop file so xdg-open can start firefox
	~/.local/share/applications/firefox.desktop "$(path_packages $package)/firefox.desktop"
)

tests() {
	validate_symlinks
}

update() {
	version_is_already_installed && return
	install "$*"
}

# the update/install function only creates a symlink.
# for this package
install() {
	install_dependencies_apt
	install_symlinks
}

always() {
	tests
}
