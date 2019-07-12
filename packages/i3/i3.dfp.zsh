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
	i3 arandr fonts-roboto fonts-roboto-hinted
	xclip rxvt-unicode-256color slop aosd-cat compton
	libnotify-bin pavucontrol:3.1-4
	zathura-cb zathura zathura-djvu zathura-pdf-poppler zathura-ps
	xbindkeys xbindkeys-config xdotool x11-xserver-utils
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )

# these are the dotfiles packages (dfp)
# this package depends on
typeset -r -a dfp_dependencies=(
	xresources
	polybar
	rofi
	urxvt
	xdg-utils
	# x11-themes icons
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
)

# the update/install function
update install() {
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
