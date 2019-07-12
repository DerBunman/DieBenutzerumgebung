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
typeset -r -a packages_ubuntu=( xdg-utils )
typeset -r -a dfp_dependencies=( )

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
	# depreacted mimetype paths for old apps
	~/.config/mimeapps.list                   "${0:h}/mimeapps.list"
	~/.local/share/applications/mimeapps.list "${0:h}/mimeapps.list"
	~/.local/share/applications/defaults.list "${0:h}/mimeapps.list"

	# desktop file so xdg-open can start firefox
	~/.local/share/applications/firefox.desktop "${0:h}/firefox.desktop"
)

tests() {
	echo "Validating installation."
	for link target in ${(kv)symlinks[@]}; do
	[ ${link:A} = ${target:A} ] || {
		echo "ERROR: symlink doesn't seem correct:"
		echo "[ "${(k)symlinks[1]:A}" != "${(v)symlinks[1]:A}" ]"
		echo "${(k)symlinks[1]:A}"
		exit 1
	}
	done
	echo "Looking good!"
}

# the update/init function only creates a symlink.
# for this package
update install() {
	install_dependencies_apt
	install_symlinks
	tests
}
