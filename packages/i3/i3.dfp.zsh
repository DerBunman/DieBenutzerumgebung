#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF MAGIC_EQUAL_SUBST

info() {
	cat <<-EOF
	This package will install the i3 config
	and also install the needed packages for
	i3. (When the package installation is enabled.)
	EOF
}

# these packages have to be installed on your system
# there may be differences between ubuntu and debian
typeset -a packages_debian=(
	rofi i3 arandr fonts-roboto fonts-roboto-hinted
	xclip rxvt-unicode-256color slop aosd-cat compton
	libnotify-bin pavucontrol
	zathura-cb zathura zathura-djvu zathura-pdf-poppler zathura-ps
	# needed for xkeys.zsh (x11-xserver-utils for xmodmap)
	xbindkeys xbindkeys-config xdotool x11-xserver-utils
)
typeset -a packages_ubuntu=( ${(@)packages_debian} )

# these are the dotfiles packages (dfp)
# this package depends on
typeset -a dfp_dependencies=(
	xressouces
	xdg polybar urxvt x11-themes icons
)

# these symlinks will be created
typeset -A links=(
	~/.config/i3/config1 "${0:h}/config"
)

# returns the dependencies for other dotfiles packages (dfp)
# but also the apt packages for debian and ubuntu systems.
# more systems may be added on a later time.
dependencies() {
	test -f \
		&& . /etc/os-release \
		|| ID=ubuntu # they are the same for this package
	typeset -A pkg_types=(
		dfp  "dfp_dependencies"
		apt  "packages_${ID:l}"
		host "host_features"
	)
	if [ "${#pkg_types[$1]}" -gt 0 ]; then
		echo "${(P)pkg_types[$1]}"
	else
		echo "ERROR: unknown package type: ${1}." 1>&2
		exit 1
	fi
}


update init() {
	for link target in ${(kv)links[@]}; do
		# TODO build lib to validate and create symlinks
		echo "ln --relative -s \"$target\" $link"
	done
}

# TODO make a include file or better a autoload
[ $# -ne 0 ] && {
	if typeset -f "$1" > /dev/null; then
		func="$1"
		shift
		"$func" "$*"
	else
		echo "ERROR: function $1 was not found in $0."
	fi
}
