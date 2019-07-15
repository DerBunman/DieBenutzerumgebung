#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package contains the default shell config files.
	And also a small set of applications and tools.
	EOF
	)"

typeset -r info_short="The shell-base: configs and applications."

# base packages cannot be deselected and so they will be
# forecd to install when all host flags match
typeset -r base_package=true

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=(
	curl
	wget
	powerline
	tmux
	mc
	ranger
	detox
	pv
	figlet
	net-tools
	apt-file
	sysfsutils
	p7zip-full
	unp
	unrar
	unzip
	grc
	silversearcher-ag
	shellcheck
	pass
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=(
	zsh
)
typeset -r -a host_flags=()

# these symlinks will be created
typeset -r -A symlinks=(
	~/.config/ranger        "$(path_packages $package)/ranger"
	~/.ssh/config           "$(path_packages $package)/ssh_config"
	~/.profile              "$(path_packages $package)/profile"
	~/.tmux.conf            "$(path_packages $package)/tmux.conf"
	~/.toprc                "$(path_packages $package)/toprc"
	~/bin/serve_via_http.sh "$(path_packages $package)/serve_via_http.sh"
	~/bin/conf              "$(path_root)/modules/conf.zsh"
	~/bin/dotfiles          "$(path_root)/dotfiles"
)

tests() {
	validate_symlinks
}

update() {
	version_is_already_installed || install_dependencies_apt
}

install() {
	install_dependencies_apt
}

always() {
	test -d "$HOME/.ssh/conf.d" || mkdir -p "$HOME/.ssh/conf.d"
	install_symlinks
	tests
}
