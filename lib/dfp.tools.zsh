. ${0:h:h}/lib/path.helpers.zsh

#                    _
#   _ __   __ _  ___| | ____ _  __ _  ___  ___
#  | '_ \ / _` |/ __| |/ / _` |/ _` |/ _ \/ __|
#  | |_) | (_| | (__|   < (_| | (_| |  __/\__ \
#  | .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/
#  |_|                         |___/
#    __ _ _ __ _ __ __ _ _   _
#   / _` | '__| '__/ _` | | | |
#  | (_| | |  | | | (_| | |_| |
#   \__,_|_|  |_|  \__,_|\__, |
#                        |___/
# generates the current global packages array
generate_packages_array() {
	packages_path=$(path_packages)
	typeset -g -A packages
	for package in $packages_path/*(/); do
		dfp_zsh="$(path_package_dfp $package:t)"
		[ -f "$dfp_zsh" ] || {
			echo "ERROR in package '${package:t}' could not find ${dfp_zsh}."
			echo "      package will be ignored."
			continue
		}
		packages+=(
			"${package:t}" "${dfp_zsh:A}"
		)
	done
}

# 
