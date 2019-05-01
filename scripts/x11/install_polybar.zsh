#!/usr/bin/env zsh
# DOTFILES_INFO: This script will install polybar
# DOTFILES_RUN_ACTIONS: init
. ${0:h}/../../lib/colorized_messages.zsh

msg_info "installing dependencies: libmpdclient2 libxcb-composite0"
sudo apt install libmpdclient2 libxcb-composite0

echo

msg_info "Please run one of these commands, based on your distro."
msg_info "Note the release name in the filname."
for item in ../../debs/*deb; do
	echo "sudo dpkg -i ${item:A}"
done

msg_info "Press ENTER to continue"
read
