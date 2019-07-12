#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package downloads RobotoMono from nerdfonts.com to ~/.local/share/fonts/NerdFonts/
	and rebuilds the cache.
	EOF
	)"

typeset -r info_short="The RobotoMono nerdfonts icon/glyph font."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=( wget unzip )
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=( )

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
)

font_path="$HOME/.local/share/fonts/NerdFonts"

tests() {
	echo "Validating installation."
	fc-list | grep "RobotoMono Nerd Font" >/dev/null
	echo "Looking good!" # MAH MAN!
}

# the update/install function only creates a symlink.
# for this package
update() {
}

install() {
	test -e "$font_path" && {
		echo "Folder exits. Delete $font_path to reinstall."
		return 0
	}
	mkdir -p "$font_path"
	cd "$font_path"
	wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/RobotoMono.zip"
	unzip "RobotoMono.zip"
	rm "RobotoMono.zip"
}

always() {
	fc-cache -fv ${font_path:h}
	tests
}
