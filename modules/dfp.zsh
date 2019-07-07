#!/usr/bin/env zsh
debug=${debug:-false}

# load needed libs
# bzcurses is loaded later on
. ${0:h}/../lib/conf.zsh
. ${0:h}/../lib/trace.zsh

setopt ERR_EXIT FUNCTION_ARG_ZERO
trap 'retval=$?; echo "ERROR in $0 on $LINENO"; trace; return $?' ERR INT TERM

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

packages_path=${0:h}/../packages

action="${1}"
shift

typeset -A packages
for package in $packages_path/*(/); do
	dfp_zsh="$packages_path/${package:t}/${package:t}.dfp.zsh"
	[ -f "$dfp_zsh" ] || {
		echo "ERROR in package '${package:t}' could not find ${dfp_zsh}."
		echo "      package will be ignored."
		continue
	}
	packages+=(
		"${package:t}" "$dfp_zsh"
	)
done

dfp_pb=${0:h}/../lib/dfp.package-builder.zsh


#   _ _     _
#  | (_)___| |_
#  | | / __| __|
#  | | \__ \ |_
#  |_|_|___/\__|
if [ "$action" = "list" ]; then
	echo "Listing packages:"
	echo "================="
	for package dfp_zsh in ${(kv)packages[@]}; do
		echo $(
			echo "$(${dfp_zsh:A} nameplus):"
			echo " | "
			${dfp_zsh:A} info_short
		)
	done | column -s'|' -t


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
	local text="Package details for ${1}:"
	echo "$text"
	echo "${(r:${#text}::=:)${}}\n"

	dfp_zsh="${(v)packages[$1]:A}"
	{
		"$dfp_zsh" details \
			|| {
			echo "ERROR $? in $0"
			exit $?
		} 1>&2

	} | column -s'|' -t -c1


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
