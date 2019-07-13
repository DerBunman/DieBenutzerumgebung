#!/usr/bin/env zsh
debug=${debug:-false}

#/path.helpers.zsh
# load needed libs
# bzcurses is loaded later on
. ${0:A:h:h}/lib/path.helpers.zsh
. ${0:A:h:h}/lib/text.helpers.zsh
. ${0:A:h:h}/lib/dfp.tools.zsh
. ${0:A:h:h}/lib/conf.zsh
. ${0:A:h:h}/lib/trace.zsh

setopt ERR_EXIT FUNCTION_ARG_ZERO
trap 'retval=$?; echo "ERROR in $0 on $LINENO"; trace; return $retval' ERR INT TERM

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
	 :::dotfiles dfp show {packagename}:::Show package details packages.
	 :::dotfiles dfp install {packagename}:::Install package.
	 :::dotfiles dfp update:::Update installed packages.
	EOF
}

[ ${#} -eq 0 ] && { help; exit }

packages_path=$(path_packages)

action="${1}"
shift

# generates the current global packages array
generate_packages_array

# dfp_pf stands for dfp package builder and it is the
# script, that wraps the data in functions and logic.
dfp_pb=$(path_dfp_pb)


#   _ _     _
#  | (_)___| |_
#  | | / __| __|
#  | | \__ \ |_
#  |_|_|___/\__|
if [ "$action" = "list" ]; then
	text_underlined "Listing packages:"

	for package dfp_zsh in ${(kv)packages[@]}; do
		installed=""
		conf_chk_dfp_installed $package && {
			installed=" (I:$(conf get dfp/installed/$package/version))"
		}
		echo $(
			echo "$($dfp_pb $package nameplus)${installed}:"
			echo " | "
			$dfp_pb $package info_short
		)
	done | column -s'|' -t
	echo ""
	text_rulem "[ Finished ]"


#       _
#   ___| |__   _____      __
#  / __| '_ \ / _ \ \ /\ / /
#  \__ \ | | | (_) \ V  V /
#  |___/_| |_|\___/ \_/\_/
elif [ "$action" = "show" ]; then
	package=$1;
   	shift

	text_underlined "Package details for ${package}:"

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
	fi

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
	if [ "$1" = "--update" ]; then
		local install=update
		shift
		local text="Updating package ${1}:"
	else
		local install=install
		local text="Installing package ${1}:"
	fi
	text_figlet "$1"
	text_underlined "$text"

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
		echo ""

		text_underlined "Installing DFP-Dependencies ..."
		for dfp in $depends_dfp; do
			conf_chk_dfp_installed $dfp || {
				echo "Installing DFP $dfp"
				"$0" install $dfp || {
					exit
				}
			}
		done
		text_underlined "Installing DFP-Dependencies ... DONE"
	fi

	# install or update the package
	$dfp_pb "$1" $install && {
		echo "Package $1 has been successfully installed.\n"
	} || {
		echo "ERROR! Install failed.\n"
		exit 1
	}


#                   _       _
#   _   _ _ __   __| | __ _| |_ ___
#  | | | | '_ \ / _` |/ _` | __/ _ \
#  | |_| | |_) | (_| | (_| | ||  __/
#   \__,_| .__/ \__,_|\__,_|\__\___|
#        |_|
elif [ "$action" = "update" ]; then
	text_underlined "Updating packages."
	for package in ${(k)packages}; do
		conf_chk_dfp_installed $package \
			&& {
				text_underlined "Updating $package"
				$dfp_pb $package update
			}
	done


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
