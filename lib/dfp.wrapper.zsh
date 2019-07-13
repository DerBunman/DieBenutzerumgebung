#!/usr/bin/env zsh
zmodload zsh/mapfile
setopt ERR_EXIT FUNCTION_ARG_ZERO
trap 'retval=$?; echo "ERROR in $0 on $LINENO"; trace; return $retval' ERR INT TERM

# load needed libs
. ${0:A:h}/path.helpers.zsh
. ${0:A:h}/conf.zsh
. ${0:A:h}/trace.zsh
. ${0:A:h}/dfp.compile_tools.zsh
. ${0:A:h}/text.helpers.zsh

# displays a small help for this wrapper
help() {
	echo "$(cat <<-EOF
	Syntax: dfp.wrapper.zsh package action [parameters]
	Eg: dfp.wrapper.zsh i3 install
	EOF
	)"
}

# package name provided?
if [ "$1" = "" ]; then
	{
		echo "ERROR: provide package name."
		echo ""
		help
	} 1>&2
	exit 1
fi

# set path for the currently wrapped package
package=$1
shift
package_dfp=$(path_package_dfp $package)
backup_dir=$(path_backup)

if [ ! -f "$package_dfp" ]; then
	echo "ERROR: could not find $package_dfp"
	exit 1

elif [ "$1" = "" ]; then
	{
		echo "ERROR: provide action."
		echo ""
		help
	} 1>&2
	exit 1

fi

# set action and its parameters
# action can be any function in this scope
action="$1"
shift
action_parameters=( $@ )
if [[ "$action" = "install" && "$(conf get dfp/installed/$package/version)" != "" ]]; then
	echo "INFO: This package is aready installed."
	echo "      Switching to update.\n"
	action="update"
fi


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
		host_flags "host_flags"
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

# recursive dfp dependencies
dfp_rdepenends() {
	local result=( ${@} )
	local dfp_wrapper=$(path_dfp_wrapper)
	for dfp in ${(@)$(dependencies dfp)}; do
		[ "${(@)result[(r)$dfp]}" = "" ] && {
			result+=( $dfp )
			result+=( $($dfp_wrapper $dfp dfp_rdepenends ${(u)result[@]}) )
		}
	done
	echo ${(u)result[@]}
}

base_package() {
	echo ${base_package:-false}
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

version_installed() {
	conf get dfp/installed/${package}/version
}

version_upstream() {
	echo ${version_upstream}
}

license() {
	echo ${license}
}

name() {
	echo ${package_name}
}

nameplus() {
	echo "${package_file:t:r:r}[$version]"
}

symlinks() {
	# ressurect array like this:
	# typeset -A symlinks=( $($dfp_wrapper "$package" symlinks) )
	printf '%q\n' "${(kv)symlinks[@]}"
}

version_is_already_installed() {
	[ "$(version_installed)" -eq $version ] && {
		echo "$package is already up2date. (v$version)\n"
		return 0
	}
	return 1
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

validate_symlinks() {
	text_underlined "Valdiating installed symlinks for $package"
	local error=0
	for link target in ${(kv)symlinks[@]}; do
		if [ "${link:A}" = "${target:A}" ]; then
			echo "[OK] Symlink exists and points to the right file:"
			echo " |-: ${link}"
			echo " \\-> ${target}\n"
		elif [ ! -e "${target}" ]; then
			echo "[ERROR] Target doesn't exist:"
			echo " |-: ${link}"
			echo " \\-> ${target}\n"
			error=1
		else
			echo "[ERROR] Symlink has some error. Please check this:"
			echo " |-: ${link}"
			echo " \\-> ${target}\n"
			error=1
		fi
	done
	return $error
}

install_symlinks() {
	text_underlined "Installing symlinks for $package"
	for link target in ${(kv)symlinks[@]}; do
		if [[ "${link:A}" = "${target:A}" && -e "${link:A}" ]]; then
			echo "[OK] Symlink exists and points to the right file:"
			echo " |-: ${link}"
			echo " \\-> ${target}\n"
			continue

		elif [[ ! -L "${link}" && -e "${link}" ]]; then
			echo "File/Directory and not link:"
			echo "${link}"
			echo "Moving to $backup_dir"
			mv "$link" "$backup_dir"

		elif [[ ! -e "$target" ]]; then
			echo "Symlink target $target does not exit."
			echo "This has to be fixed. before we can continue."
			exit 1

		elif [[ -L "${link}" ]]; then
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

		echo "Creating symlink:"
		echo " |-: ${link}"
		echo " \\->  ${target}\n"
		
		test -e "${link:h}" || mkdir -p "${link:h}"
		ln -v --relative -s "$target" "$link"
	done
}

install_dependencies_apt() {
	local deps=( ${(@)$(dependencies apt)} )
	if [ ${#deps} -eq 0 ]; then
		echo "INFO: Package has no apt dependencies."
		return
	fi
	text_underlined "Installing apt packages:"
	echo "${deps}\n"
	sudo apt-get install --yes ${deps} || exit $?
	echo ""
	return 0
}


depends_dfp() {
	if [ "$1" = "" ]; then
		deps_tmp_file="$(mktemp)"
	else
		deps_tmp_file="$1"
	fi
	
	local deps=("${(f@)mapfile[$deps_tmp_file]}")

	for dfp in $dfp_dependencies; do
		if [ ${#deps[(r)$dfp]} -eq 0 ]; then
			echo $dfp >> $deps_tmp_file
			$ZSH_ARGZERO $dfp depends_dfp "${deps_tmp_file}"
		fi
	done

	# if $1 is not set, we are in the first call to this
	# function. so we return the deps.
	[ "$1" = "" ] && {
		cat "$deps_tmp_file" && rm "$deps_tmp_file"
	}
	exit 0
}








# Include package definition
. $package_dfp

validate



# validate stuff before install/update
[[ "$action" = "install" \
	|| $action = "update" \
	&& ${#host_flags} -ne 0 ]] && {
	local host_flags_enabled=(
		${(@)$(conf get dotfiles/host_flags/checked)}
	)
	for flag in $host_flags; do
		[ "$host_flags_enabled[(r)$flag]" = "$flag" ] || {
			echo "ERROR: host flag not enabled: $flag"
			echo "       enable or gtfo."
			exit 1
		} 1>&2
	done
}

# wrapper that calls the functions for the package handling
setopt ERR_EXIT
if typeset -f "$action" > /dev/null; then
	"$action" ${(@)action_parameters} || exit $?
else
	echo "ERROR: function $action was not found in ${package_dfp:A}." 1>&2
	exit 1

fi


if [[ "$action" = "update" || "$action" = "install" ]]; then
	if typeset -f "always" > /dev/null; then
		always "$action_parameters"
	fi
	version | conf put dfp/installed/$package/version
	echo "SUCCESS!"
fi

