#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package will install i3keys.
	EOF
	)"

typeset -r info_short="i3keys package"

typeset -r package_file=$0
typeset -r package_name=${0:t:r:r}


typeset -r -i version=1

typeset -r license="MIT"

# these packages have to be installed on your system
# there may be differences between ubuntu and debian
typeset -r -a packages_debian=(
	golang-go
	libxtst-dev
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )

# these are the dotfiles packages (dfp)
# this package depends on
typeset -r -a dfp_dependencies=(
	i3
)

typeset -r -a host_flags=(
	has_x11
)

# these symlinks will be created
typeset -r -A symlinks=(
)

# the update/install function
update() {
	version_is_already_installed && return
	install "$*"
}

install() {
	install_dependencies_apt

	go get -u github.com/RasmusLindroth/i3keys
	cd $HOME/go/src/github.com/RasmusLindroth/i3keys

	GOBIN=$HOME/bin/ go install
}

# this will be called afer init/update
# to veryfy that the installation is complete
tests() {
	test -f $HOME/bin/i3keys
}

always(){
	tests
}
