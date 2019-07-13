#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package contains the xkeys keymapper.
	It can (and will) change the keyboard layout
	using xmodmap and/or bind actions via xbindkeys.
	EOF
	)"

typeset -r info_short="The xkeys keymapper."

typeset -r package_file=$0
typeset -r package_name=${0:t:r:r}


typeset -r -i version=1

typeset -r license="MIT"

# these packages have to be installed on your system
# there may be differences between ubuntu and debian
typeset -r -a packages_debian=(
	xbindkeys
	xbindkeys-config
	xdotool
	x11-xserver-utils
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )

# these are the dotfiles packages (dfp)
# this package depends on
typeset -r -a dfp_dependencies=(
	i3
	x11-base
)

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/.xkeys                  "$(path_packages $package)/xkeys"
	~/bin/autostart/xkeys.zsh "$(path_packages $package)/xkeys.zsh"
	~/bin/xkeys.zsh           "$(path_packages $package)/xkeys.zsh"
)

# the update/install function
update install() {
	install_dependencies_apt
	install_symlinks
}

# this will be called afer init/update
# to veryfy that the installation is complete
tests() {
	validate_symlinks
}

always() {
	tests
}
