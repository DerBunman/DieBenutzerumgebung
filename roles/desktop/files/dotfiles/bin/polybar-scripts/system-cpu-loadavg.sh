#!/bin/sh
# =====================================
# << THIS FILE IS MANAGED BY ANSIBLE >>
# =====================================
#
# DO NOT EDIT THIS FILE - CHANGES WILL BE OVERWRITTEN
# INSTEAD CHANGE THIS FILE IN THE ANSIBLE REPOSITORY.


awk '{print $1" "$2" "$3}' < /proc/loadavg
