#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package contains the GTK2/3 theme DieOberflaechengestaltung which
	consists of a Numinx based theme and icons.
	The theme has been customized for DieBenutzeroberflaeche, using oomox.
	The oomox sources are included.
	EOF
	)"

typeset -r info_short="DieOberflaechengestaltung GTK2/3 theme/icon set."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=(
	git
	gconf2
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=( )

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/.config/oomox                           "$(path_packages $package)/repo/config/oomox"
	~/.config/gtk-3.0                         "$(path_packages $package)/repo/config/gtk-3.0"
	~/.gtkrc-2.0                              "$(path_packages $package)/repo/config/gtkrc-2.0"
	~/.icons/actions                          "$(path_packages $package)/repo/icons/actions"
	~/.icons/animations                       "$(path_packages $package)/repo/icons/animations"
	~/.icons/apps                             "$(path_packages $package)/repo/icons/apps"
	~/.icons/categories                       "$(path_packages $package)/repo/icons/categories"
	~/.icons/default                          "$(path_packages $package)/repo/icons/default"
	~/.icons/devices                          "$(path_packages $package)/repo/icons/devices"
	~/.icons/emblems                          "$(path_packages $package)/repo/icons/emblems"
	~/.icons/emotes                           "$(path_packages $package)/repo/icons/emotes"
	~/.icons/mimetypes                        "$(path_packages $package)/repo/icons/mimetypes"
	~/.icons/oomox-DieOberflaechengestaltung  "$(path_packages $package)/repo/icons/oomox-DieOberflaechengestaltung"
	~/.icons/places                           "$(path_packages $package)/repo/icons/places"
	~/.icons/status                           "$(path_packages $package)/repo/icons/status"
	~/.icons/screenshot_clipboard.svg         "$(path_packages $package)/repo/icons/screenshot_clipboard.svg"
	~/.icons/xkeys.svg                        "$(path_packages $package)/repo/icons/xkeys.svg"
	~/.themes/oomox-DieOberflaechengestaltung "$(path_packages $package)/repo/themes/oomox-DieOberflaechengestaltung"

)

# the update/install function only creates a symlink.
# for this package
update() {
	text_underlined "Update local git repo"
	cd "$(path_packages $package)/repo"
	git pull
	cd -
	echo ""

	install_symlinks
}

install() {
	text_underlined "Clone to local git repo"
	git clone \
		https://github.com/DerBunman/DieOberflaechengestaltung \
		"$(path_packages $package)/repo" || exit 1

	install_symlinks
}

tests() {
	validate_symlinks
}

always() {
	touch "$HOME/.gtkrc-2.0.mine"
	text_underlined "setting gtk-theme to 'oomox-DieOberflaechengestaltung'."
	gsettings set org.gnome.desktop.interface gtk-theme "oomox-DieOberflaechengestaltung"
	gsettings set org.gnome.desktop.wm.preferences theme "oomox-DieOberflaechengestaltung"
	tests
}
