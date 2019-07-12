path_root() {
	echo "$ZSH_ARGZERO:h:h:A"
}

path_lib() {
	echo "$(path_root)/lib"
}

path_backup() {
	echo "$(path_root)/backup"
}

path_packages() {
	if [ "$1" != "" ]; then
		local package_path="$(path_root)/packages/$1"
		echo "$package_path"
	else
		echo "$(path_root)/packages"
	fi
}

path_module_dfp() {
	echo $(path_root)/modules/dfp.sh
}

path_package_dfp() {
	echo "$(path_packages $1)/$1.dfp.zsh"
}

path_dfp_pb() {
	echo "$(path_lib)/dfp.package-builder.zsh"
}
