#!/usr/bin/env zsh
# DOTFILES_INFO: This script will download and install dropbox
# DOTFILES_INFO: to the following path: ~/.dropbox-dist/ and
# DOTFILES_INFO: create a symlink to ~/bin/dropboxd and autostart
# DOTFILES_INFO: The script will ask before each action
. ${0:h}/../../lib/colorized_messages.zsh

yesno "Download and install dropbox?" && {
	cd ~
	wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	test -L bin/dropboxd || ln -s ~/.dropbox-dist/dropboxd ~/bin/dropboxd

	yesno "Add link to ~/bin/autostart/?" && {
		ln -s ~/.dropbox-dist/dropboxd ~/bin/autostart/dropboxd
	}

	yesno "Run and setup dropbox?" && bin/dropboxd &
}
