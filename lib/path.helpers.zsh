# set path when parsing this file
# because it is a pain in the function to find
# out in which file we are.
typeset -g path_root="$0:A:h:h"

path_root() {
	echo "$path_root"
}

path_lib() {
	echo "$(path_root)/lib"
}

path_backup() {
	local backup_path="$(path_root)/tmp/backup"
	test -d "$backup_path" || mkdir -p "$backup_path"
	echo $backup_path
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

path_dfp_wrapper() {
	echo "$(path_lib)/dfp.wrapper.zsh"
}
