#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package will install the i3 config
	and also install the needed packages for
	i3. (When the package installation is enabled.)
	EOF
	)"

typeset -r info_short="i3 packages and config files"

typeset -r package_file=$0
typeset -r package_name=${0:t:r:r}


typeset -r -i version=1

typeset -r license="MIT"

# these packages have to be installed on your system
# there may be differences between ubuntu and debian
typeset -r -a packages_debian=(
	i3
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )

# these are the dotfiles packages (dfp)
# this package depends on
typeset -r -a dfp_dependencies=(
	x11-base
	polybar
	rofi
	urxvt
	xdg-utils
	x11-themes
)

typeset -r -a host_flags=(
	has_x11
	has_root
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/.config/i3/config      "$(path_packages $package)/config"
	~/bin/i3-applet-wrapper  "$(path_packages $package)/i3-applet-wrapper"
	~/bin/i3-autostart.zsh   "$(path_packages $package)/i3-autostart.zsh"
	~/bin/i3subscribe        "$(path_packages $package)/i3subscribe"
	~/bin/screenshot         "$(path_packages $package)/screenshot"
	~/bin/tint_screen.zsh    "$(path_packages $package)/tint_screen.zsh"
	~/bin/compton-invert     "$(path_packages $package)/compton-invert"
	~/bin/layout_manager.sh  "$(path_packages $package)/layout_manager.sh"

	~/bin/autostart/i3-scratchpad-vim.zsh
		"$(path_packages $package)/autostart/i3-scratchpad-vim.zsh"

	~/bin/autostart/always/udiskie.zsh
		"$(path_packages $package)/autostart/always/udiskie.zsh"

	~/bin/autostart/always/xrdb_reload.sh
		"$(path_packages $package)/autostart/always/xrdb_reload.sh"

	~/bin/autostart/always/setxkbmap.zsh
		"$(path_packages $package)/autostart/always/setxkbmap.zsh"
)

# the update/install function
update() {
	version_is_already_installed || install_dependencies_apt
}

install() {
	install_dependencies_apt
}

# this will be called afer init/update
# to veryfy that the installation is complete
tests() {
	validate_symlinks
}

always() {
	test -d ~/bin/autostart/always || mkdir -p ~/bin/autostart/always
	install_symlinks
	tests
}
