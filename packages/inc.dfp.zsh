# load conf lib
. ${0:h}/../lib/conf.zsh

backup_dir=${0:h}/../backups/

# returns the dependencies for other dotfiles packages (dfp)
# but also the apt packages for debian and ubuntu systems.
# more systems may be added on a later time.
dependencies() {
	test -f \
		&& . /etc/os-release \
		|| ID=ubuntu # they are the same for most packages
	typeset -A pkg_types=(
		dfp        "dfp_dependencies"
		apt        "packages_${ID:l}"
		host_flags "host_features"
	)
	if [ "${#pkg_types[$1]}" -gt 0 ]; then
		echo "${(P)pkg_types[$1]}"
	else
		{
			echo "ERROR: unknown package type: ${1}."
			echo "Known types: ${(k)pkg_types}"
		} 1>&2
		exit 1
	fi
}

info() {
	echo "${info}"
}
info_short() {
	echo "$info_short"
}

version() {
	echo ${version}
}

name() {
	echo ${package_name}
}

nameplus() {
	echo "${package_file:t:r:r}[$version]"
}

# validates that the dfp has all variables are set
# and also are from the correct type
validate() {
	typeset -A expected_types=(
		info             scalar-readonly
		info_short       scalar-readonly
		package_file     scalar-readonly
		package_file     scalar-readonly
		license          scalar-readonly
		packages_debian  array-readonly
		packages_ubuntu  array-readonly
		dfp_dependencies array-readonly
		host_flags       array-readonly
		version          integer-readonly
		symlinks         association-readonly
	)
	local error=0
	for function_name in ${(k)expected_types}; do
		[ "${(tP)function_name}" != ${(v)expected_types[$function_name]} ] && {
			echo "WARN!:\tin package ${package_file:t} with parameter $function_name"
			echo "\tbeeing of type ${(tP)function_name} instead of ${(v)expected_types[$function_name]}\n"
			error=1
		}
	done 1>&2
	return $error
}

install_symlinks() {
	for link target in ${(kv)symlinks[@]}; do
		if [ ${link:A} = ${target:A} ]; then
			echo "[OK] Symlink exists and points to the right file:"
			echo "${link}"
			continue

		elif [[ ! -L "${link}" && -e "${link}" ]]; then
			echo "File/Directory and not link:"
			echo "${link}"
			echo "Moving to "
			echo mv "$link" "$backup_dir"

		elif [[ ! -e "$target" ]]; then
			echo "Symlink target does not exit."
			echo "This has to be fixed. before we can continue."
			exit 1

		elif [[ -L "${link}" && ${link:A} != ${target:A} ]]; then
			echo "Symlink exists and is wrong or broken:"
			echo "${link}"
			echo "  points to"
			echo "   ${link:A}"
			echo "  should point to"
			echo "   ${target:A}"
			echo
			echo "  -> Delete and relink."
			rm "${link}"
		fi
		ln -v --relative -s "$target" "$link"
	done
}

# doesnt work yet as it should
validate_symlinks() {
	echo "Symlinks:|"
	for link target in ${(kv)symlinks[@]}; do
		if [ ${link:A} = ${target:A} ]; then
			echo " |Symlink exists and points to the right file:"
			echo " |${link}"
			echo " |${target}"

		elif [[ ! -L "${link:A}" && ! -z "${link:A}" ]]; then
			echo " |File/Directory and not link:"
			echo " |${link}"


		elif [ "${link:a}" != "" ]; then
			echo " |Symlink exists has is wrong:"
			echo " |${link}"
			echo " |  points to"
			echo " |   ${link:a}"
			echo " |  should point to to"
			echo " |   ${target:a}"
		fi
	done
}

validate_dependencies_apt() {
	echo "APT-deps:|"
	local deps=( ${(@)$(dependencies apt)} )
	if [ ${#deps} -eq 0 ]; then
		echo " |no dependencies"
		return
	fi
	{
	echo " |status!package!installed!depends on version"
	for apt_package in ${deps}; do
		apt_package=("${(@s/:/)apt_package}")
		installed_version=$(apt-cache policy $apt_package[1] \
			| grep -oP 'Installed: \K.*([^ ]*)' \
			| grep -v '(none)' )

		local retval=$?
		local pkg_status=${installed_version:-MISSING}

		ok="MISSING"
		if [[ "${pkg_status}" != "MISSING" && ${apt_package[2]:--} != '-' ]]; then
			dpkg --compare-versions "${pkg_status}" gt ${apt_package[2]:-999999} && {
				ok="OK "
			} || {
				ok="TOO OLD"
			}
		elif [[ "${pkg_status}" != "MISSING" ]]; then
			ok="OK"
		fi
		echo " |$ok!$apt_package[1]!(I:$pkg_status)!(D:${apt_package[2]:--})"
	done
	} | column -t -s'!'
}


validate_dependencies_host_flags() {
	echo "Host Flags:|"
	local flags_enabled=( ${(@)$(conf get dotfiles/host_flags_enabled)} )
	for flag in $host_flags; do
		[ "$flags_enabled[(r)$flag]" = "$flag" ] && {
			echo " |OK!$flag"
		} || {
			echo " |OFF!$flag"
		}
	done | column -t -s'!'
}

validate_dependencies_dfp() {
	if [ ${#dfp_dependencies} -eq 0 ]; then
		return 0
	fi
	echo "DFP-deps:|"
	for dfp in $dfp_dependencies; do
		ok="INSTALLED"

		conf_chk_dfp_installed "$dfp" \
			|| ok="MISSING"

		echo " |$ok!$dfp"
	done | column -t -s'!'
}

details() {
	echo "info_short:|${info_short}"
	echo "info:|${info}"
	echo "version:|${version}"
	echo "license:|${license}"
	validate
	if [ $? -eq 0 ]; then
		echo "self-check:|SUCCESS"
	else
		echo "self-check:|FAILED!"
	fi
	validate_symlinks
	validate_dependencies_host_flags
	validate_dependencies_dfp
	validate_dependencies_apt
}

# wrapper that calls the functions for the package handling
[ $# -ne 0 ] && {
	if typeset -f "$1" > /dev/null; then
		func="$1"
		shift
		"$func" "$*"
	else
		echo "ERROR: function $1 was not found in $0."
	fi
}