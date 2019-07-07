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

typeset -r license="TEST"

# these packages have to be installed on your system
# there may be differences between ubuntu and debian
typeset -r -a packages_debian=(
	rofi i3 arandr fonts-roboto fonts-roboto-hinted
	xclip rxvt-unicode-256color slop aosd-cat compton
	libnotify-bin pavucontrol:3.1-4
	zathura-cb zathura zathura-djvu zathura-pdf-poppler zathura-ps
	# needed for xkeys.zsh (x11-xserver-utils for xmodmap)
	xbindkeys xbindkeys-config xdotool x11-xserver-utils
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )

# these are the dotfiles packages (dfp)
# this package depends on
typeset -r -a dfp_dependencies=(
	xresources
	#xdg polybar urxvt x11-themes icons
)

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/.config/i3/config1 "${0:h}/config"
)

# the update/init function
update init() {
	for link target in ${(kv)symlinks[@]}; do
		# TODO build lib to validate and create symsymlinks
		echo "ln --relative -s \"$target\" $link"
	done
}

# this will be called afer init/update
# to veryfy that the installation is complete
tests() {
}
