#!/usr/bin/env zsh
debug=${debug:-false}
unsetopt FUNCTION_ARGZERO

# load needed libs
# bzcurses is loaded later on
. ${0:h}/../lib/conf.zsh

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
	packages+=(
		"${package:t}" "$dfp_zsh"
	)
done

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

	dfp_zsh="${(v)packages[$1]:A}"
	"$dfp_zsh" init "$1" && {
		echo "Package $1 has been successfully installed."
		"$dfp_zsh" version | conf put "dfp/installed/$1"
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
