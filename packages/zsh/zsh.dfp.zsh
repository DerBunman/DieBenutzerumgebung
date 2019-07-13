#!/usr/bin/env zsh
setopt MULTI_FUNC_DEF

typeset -r info="$(<<-EOF
	This package contains zsh and its zplug based config.
	EOF
	)"

typeset -r info_short="The zShell (zsh) and its config."

typeset -r package_file=$0

typeset -r -i version=1

typeset -r license="MIT"

typeset -r -a packages_debian=(
	zsh git
)
typeset -r -a packages_ubuntu=( ${(@)packages_debian} )
typeset -r -a dfp_dependencies=()
typeset -r -a host_flags=()

# these symlinks will be created
typeset -r -A symlinks=(
	~/.zsh-dircolors.config "$(path_packages $package)/zsh-dircolors.config"
	~/.zsh_autocomplete     "$(path_packages $package)/zsh_autocomplete"
	~/.zshenv               "$(path_packages $package)/zshenv"
	~/.zshrc                "$(path_packages $package)/zshrc"
	~/.zshrc.d              "$(path_packages $package)/zshrc.d"
)

tests() {
	validate_symlinks
}

update() {
	install_dependencies_apt
	install_symlinks
}


install() {
	install_dependencies_apt
	install_symlinks
	sudo chsh -s /usr/bin/zsh $USER
}

always() {
	tests
}
