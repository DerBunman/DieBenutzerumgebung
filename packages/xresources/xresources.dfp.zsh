#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package contains the ~/.Xressources file which defines
	the basic colors used by most applications.
	EOF
	)"

typeset -r info_short="The ~/.Xressources file."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=()
typeset -r -a packages_ubuntu=()
typeset -r -a dfp_dependencies=( )

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/.Xresources "${0:h}/Xresources"
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
	install_symlinks \
		&& tests
}
