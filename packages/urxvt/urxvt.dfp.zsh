#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package installs the urxvt terminal and its config.
	EOF
	)"

typeset -r info_short="The urxvt terminal."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=( rxvt-unicode-256color )
typeset -r -a packages_ubuntu=(  ${(@)packages_debian} )
typeset -r -a dfp_dependencies=(
	xresources
)

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/.config/urxvt                     "${0:A:h}/urxvt"
	~/.terminfo/r/rxvt-unicode-256color "${0:A:h}/rxvt-unicode-256color"
)

tests() {
	validate_symlinks
}

# the update/install function only creates a symlink.
# for this package
update() {
	install_symlinks
}

install() {
	install_dependencies_apt
	install_symlinks
}

always() {
	tests
}
