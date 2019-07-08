#!/usr/bin/env zsh
debug=${debug:-false}

# load needed libs
# bzcurses is loaded later on
. ${0:h:h}/lib/path.helpers.zsh
. ${0:h:h}/lib/text.helpers.zsh
. ${0:h:h}/lib/conf.zsh
. ${0:h:h}/lib/trace.zsh

setopt ERR_EXIT FUNCTION_ARG_ZERO
trap 'retval=$?; echo "ERROR in $0 on $LINENO"; trace; exit $?' ERR INT TERM

cat <<'EOF'
      _  __                _
   __| |/ _|_ __   _______| |__
  / _` | |_| '_ \ |_  / __| '_ \
 | (_| |  _| |_) | / /\__ \ | | |
  \__,_|_| | .__(_)___|___/_| |_|
           |_| -----------------

EOF

function help() {
	cat <<-EOF |  column -s':::' -t
	Usage
	=====
	 :::dotfiles dfp list:::List all packages.
	 :::dotfiles dfp list-installed:::List only installed packages.
	 :::dotfiles dfp show {packagename}:::Show package details packages.
	 :::dotfiles dfp install {packagename}:::Install package.
	 :::dotfiles dfp remove {packagename}:::Install package.
	EOF
}

[ ${#} -eq 0 ] && { help; exit }

packages_path=$(path_packages)

action="${1}"
shift

typeset -A packages
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

# dfp_pf stands for dfp package builder and it is the
# script, that wraps the data in functions and logic.
dfp_pb=$(path_dfp_pb)


#   _ _     _
#  | (_)___| |_
#  | | / __| __|
#  | | \__ \ |_
#  |_|_|___/\__|
if [ "$action" = "list" ]; then
	text_unterlined "Listing packages:"

	for package dfp_zsh in ${(kv)packages[@]}; do
		echo $(
			echo "$($dfp_pb $package nameplus):"
			echo " | "
			$dfp_pb $package info_short
		)
	done | column -s'|' -t
	echo ""
	text_rulem "[ Finished ]"

#   _ _     _        _           _        _ _          _
#  | (_)___| |_     (_)_ __  ___| |_ __ _| | | ___  __| |
#  | | / __| __|____| | '_ \/ __| __/ _` | | |/ _ \/ _` |
#  | | \__ \ ||_____| | | | \__ \ || (_| | | |  __/ (_| |
#  |_|_|___/\__|    |_|_| |_|___/\__\__,_|_|_|\___|\__,_|
elif [ "$action" = "list-installed" ]; then
	echo ""


#       _
#   ___| |__   _____      __
#  / __| '_ \ / _ \ \ /\ / /
#  \__ \ | | | (_) \ V  V /
#  |___/_| |_|\___/ \_/\_/
elif [ "$action" = "show" ]; then
	package=$1;
   	shift

	text_unterlined "Package details for ${package}:"

	$dfp_pb "$package" info
	echo ""
	{
		echo "info_short:|$( $dfp_pb "$package" info_short )"

		echo "version:|$( $dfp_pb "$package" version ) dfp"
		echo "version:|${$( $dfp_pb "$package" version_upstream ):-no upsteam} upstream"

		echo "license:|$( $dfp_pb "$package" license )"

		$dfp_pb "$package" validate
		if [ $? -eq 0 ]; then
			echo "self-check:|SUCCESS"
		else
			echo "self-check:|FAILED"
		fi
	} | column -s'|' -t -c1

	# Symlinks
	echo ""
	text_rulem "[ Symlinks ]"
	typeset -A symlinks=( $($dfp_pb "$package" symlinks) )
	if [ ${#symlinks} -eq 0 ]; then
		echo "no symlinks needed\n"
	else
		for link target in ${(kv)symlinks}; do
			echo ${link} $target
		done | column -t -s' '
		echo ""

		# APT
		text_rulem "[ APT-dependencies ]"
		local deps=( ${(@)$($dfp_pb "$package" dependencies apt)} )
		if [ ${#deps} -eq 0 ]; then
			echo "no dependencies\n"
		else
			{
			echo "status!package!installed!depends on version"
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
				echo "$ok!$apt_package[1]!(I:$pkg_status)!(D:${apt_package[2]:--})"
			done
			} | column -t -s'!'
			echo ""
		fi
	fi

	# host_flags
	text_rulem "[ Host Flags ]"
	local host_flags=( ${(@)$($dfp_pb "$package" dependencies host_flags)} )
	if [ ${#host_flags} -eq 0 ]; then
		echo "no flags needed\n"
	else
		local flags_enabled=(
			${(@)$(conf get dotfiles/host_flags_enabled)}
		)
		
		{
			echo "status!flag"
			for flag in $host_flags; do
				[ "$flags_enabled[(r)$flag]" = "$flag" ] && {
					echo "OK!$flag"
				} || {
					echo "OFF!$flag"
				}
			done 
		} | column -t -s'!'
		echo ""
	fi

	# DFP deps
	text_rulem "[ DFP-Dependencies ]"
	local dfp_dependencies=( ${(@)$($dfp_pb "$package" dependencies dfp)} )
	if [ ${#dfp_dependencies} -eq 0 ]; then
		echo "no dependencies\n"
	else
		{
			echo "status!package"
			for dfp in $dfp_dependencies; do
				ok="INSTALLED"

				conf_chk_dfp_installed "$dfp" \
					|| ok="MISSING"

				echo "$ok!$dfp"
			done
		} | column -t -s'!'
	fi
	echo ""

	# end of package detail page
	text_rulem "[ Finished ]"
	echo ""


#   _           _        _ _
#  (_)_ __  ___| |_ __ _| | |
#  | | '_ \/ __| __/ _` | | |
#  | | | | \__ \ || (_| | | |
#  |_|_| |_|___/\__\__,_|_|_|
elif [ "$action" = "install" ]; then
	local text="Installing package ${1}:"
	echo "$text"
	echo "${(r:${#text}::=:)${}}\n"

	depends_dfp=( "${(f@)$($dfp_pb "$1" depends_dfp)}" )
	if [ "${depends_dfp}" = "" ]; then
		echo "DFP-Dependencies: none"
	else
		echo "DFP-Dependencies:"
		for dfp in $depends_dfp; do
			conf_chk_dfp_installed $dfp && {
				echo "$dfp (installed)"
			} || {
				echo "$dfp (missing)"
			}
		done

		echo "Installing DFP-Dependencies ..."
		for dfp in $depends_dfp; do
			conf_chk_dfp_installed $dfp || {
				echo "Installing DFP $dfp"
				"$0" install $dfp
			}
		done
	fi

	$dfp_pb "$1" update && {
		echo "Package $1 has been successfully installed."
	} || {
		echo "ERROR! Install failed."
		exit 1
	}


#   _ __ ___ _ __ ___   _____   _____
#  | '__/ _ \ '_ ` _ \ / _ \ \ / / _ \
#  | | |  __/ | | | | | (_) \ V /  __/
#  |_|  \___|_| |_| |_|\___/ \_/ \___|
elif [ "$action" = "remove" ]; then
	echo ""


#    ___ _ __ _ __ ___  _ __
#   / _ \ '__| '__/ _ \| '__|
#  |  __/ |  | | | (_) | |
#   \___|_|  |_|  \___/|_|
else
	help
	{
		echo ""
		echo "ERROR: unknown parameters: $*"
		echo "ERROR: does not compute!"
	} 1>&2
	exit 1

fi
