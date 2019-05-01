#!/usr/bin/env zsh
# DOTFILES_INFO: This script will install polybar
# DOTFILES_RUN_ACTIONS: init
. ${0:h}/../../lib/colorized_messages.zsh

msg_info "installing dependencies: libmpdclient2 libxcb-composite0"
sudo apt install libmpdclient2 libxcb-composite0

echo

. /etc/os-release
if [ "$UBUNTU_CODENAME" = "bionic" ]; then
	deb="${0:h}/../../debs/polybar*-bionic-*deb"

elif [ "$UBUNTU_CODENAME" = "disco" ]; then
	deb="${0:h}/../../debs/polybar*-disco-*deb"

elif [ "$PRETTY_NAME" = "Debian GNU/Linux buster/sid" ]; then
	deb="${0:h}/../../debs/polybar*-testing-*deb"

fi

test -e $~deb && {
	yesno "install $~deb?"
	sudo dpkg -i $~deb
	sudo apt-get install -f
	exit
}

msg_error "Could not determine the correkt deb file to install."
msg_info "Please run one of these commands, based on your distro."
msg_info "Note the release name in the filname."
for item in ${0:h}/../../debs/*deb; do
	echo "sudo dpkg -i ${item:A}"
done

msg_info "Press ENTER to continue"
read
