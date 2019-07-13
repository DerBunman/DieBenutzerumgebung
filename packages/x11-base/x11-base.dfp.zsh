#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package contains the default x11 config files like
	~/.Xressources, ~/.xprofile, ~/.config/compton.conf
	And also a small set of applications and tools.
	EOF
	)"

typeset -r info_short="The x11-base: configs and applications."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=(
	xbindkeys xbindkeys-config xdotool x11-xserver-utils

	compton arandr fonts-roboto fonts-roboto-hinted
	xclip slop aosd-cat compton libnotify-bin
	zathura-cb zathura zathura-djvu zathura-pdf-poppler zathura-ps
	pavucontrol arandr indicator-cpufreq udiskie
	feh xclip lxappearance

	xscreensaver-screensaver-webcollage xscreensaver
	xscreensaver-screensaver-bsod xscreensaver-gl-extra
	xscreensaver-gl xscreensaver-data-extra

)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=(
	shell-base
)

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/.Xresources          "$(path_packages $package)/Xresources"
	~/.xprofile            "$(path_packages $package)/xprofile"
	~/.config/compton.conf "$(path_packages $package)/compton.conf"
	~/.config/dunst        "$(path_packages $package)/dunst"
	~/bin/bosd_cat         "$(path_packages $package)/bosd_cat"
)

tests() {
	validate_symlinks
}

# the update/install function only creates a symlink.
# for this package
update install() {
	install_dependencies_apt
	install_symlinks
}

always() {
	test -f "${HOME}/.Xresources.local" \
		|| touch "${HOME}/.Xresources.local"

	tests
}
