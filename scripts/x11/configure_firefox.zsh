#!/usr/bin/env zsh
# DOTFILES_INFO: This script will add an css exception
# DOTFILES_INFO: so that all input files are NOT changed
# DOTFILES_INFO: by the GTK theme.
# DOTFILES_RUN_ACTIONS: init
. ${0:h}/../../lib/colorized_messages.zsh

#for profile in "${HOME}"/.mozilla/firefox/*default; do
#	msg_info "Processing profile: ${profile:t}"
#	msg_info "Creating directory ${profile}/chrome"
#	mkdir -p "${profile}/chrome"
#	user_content="${profile}/chrome/userContent.css"
#	test -e "$user_content" && {
#		msg_error "File $user_content exists."
#		msg_info "Maybe it is already the right one:"
#		cat "$user_content"
#		continue
#	}
#	cat <<-EOF > "$user_content"
#		input[type="email"],
#		input[type="number"],
#		input[type="tel"],
#		input[type="text"],
#		input[type="url"]
#		textarea
#		{
#			background: red;
#			color: #00FF00 !important;
#		}
#
#		input[type="password"]
#		{
#			background: yellow;
#			color: black;
#		}
#	EOF
#done

yesno "Install ublock-origin" && {
	firefox -url "https://addons.mozilla.org/firefox/downloads/file/1730458/"
}

yesno "Install Text Contrast for Dark Themes" && {
	firefox -url "https://addons.mozilla.org/firefox/downloads/file/1721952/"
}

msg_warning "Install tridactyl form remote url:"
msg_info " https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi"
yesno "" && {
	tmp_file=$(mktemp --suffix=.xpi)
	curl -fsSl https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi > "${tmp_file}"
	firefox -url "file://${tmp_file}"
}

msg_warning "Install tridactyl native support form remote url:"
msg_info " https://raw.githubusercontent.com/tridactyl/tridactyl/master/native/install.sh"
yesno "" && {
	tmp_file=$(mktemp)
	curl -fsSl https://raw.githubusercontent.com/tridactyl/tridactyl/master/native/install.sh > "${tmp_file}"
	less "${tmp_file}"
	yesno "Run this script?" && {
		bash < "${tmp_file}"
	}
}
