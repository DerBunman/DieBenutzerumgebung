#!/bin/sh
# =====================================
# << THIS FILE IS MANAGED BY ANSIBLE >>
# =====================================
#
# DO NOT EDIT THIS FILE - CHANGES WILL BE OVERWRITTEN
# INSTEAD CHANGE THIS FILE IN THE ANSIBLE REPOSITORY.

which cpupower >/dev/null 2>&1 \
	&& cpupower frequency-info -fm | grep -oP '(?<=frequency: )([^ ]+ [^ ]+)' \
	|| echo "install cpupower"
