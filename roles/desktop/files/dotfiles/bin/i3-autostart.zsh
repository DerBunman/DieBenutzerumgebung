#!/usr/bin/env zsh
# =====================================
# << THIS FILE IS MANAGED BY ANSIBLE >>
# =====================================
#
# DO NOT EDIT THIS FILE - CHANGES WILL BE OVERWRITTEN
# INSTEAD CHANGE THIS FILE IN THE ANSIBLE REPOSITORY.

[ $# -eq 0 ] && {
	echo "please provide folder with scripts"
}

while [ $# -gt 0 ]; do
	test -d "${1}" || {
		echo "dir ${1} doesn't exist"
	}
	unset files
	files=(${1}/*) && for file in $files; do
		test -f "${file}" \
			&& test -x "${file}" \
			&& {
				notify-send --icon=gtk-info "Autostart" "${file:t}"
				exec "${file}" &|
			}
	done

	shift
done
