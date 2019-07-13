#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package installs dropbox.
	EOF
	)"

typeset -r info_short="Dropbox installer."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=()
typeset -r -a packages_ubuntu=(  ${(@)packages_debian} )
typeset -r -a dfp_dependencies=(
	x11-base
)

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
	~/bin/dropboxd           ~/.dropbox-dist/dropboxd
	~/bin/autostart/dropboxd ~/.dropbox-dist/dropboxd
)

tests() {
	validate_symlinks
}

# the update/install function only creates a symlink.
# for this package
update() {
	version_is_already_installed && return
	install "$*"
}

install() {
	cd ~
	echo "Downloading dropbox to ~/.dropbox-dist/"
	wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	ln -s ~/.dropbox-dist/dropboxd ~/bin/autostart/dropboxd
}

always() {
	install_symlinks
	tests
}
