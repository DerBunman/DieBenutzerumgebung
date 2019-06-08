#!/usr/bin/env zsh
# DOTFILES_INFO: this script downloads the slop configs for
# DOTFILES_INFO: select boxes and links them to ~/.config/slop
# DOTFILES_FORCE_RUN
# DOTFILES_RUN_ACTIONS: init, update
. ${0:h}/../../lib/colorized_messages.zsh

REPO_PATH="$HOME/.repos/dotfiles_repos/slop"
CONF_DIR="$HOME/.config/slop"

if [ ! -d "$REPO_PATH" ]; then
	msg_info "Repository not found at: $REPO_PATH"
	msg_info "checking out https://github.com/naelstrof/slop to $REPO_PATH"
	git clone https://github.com/naelstrof/slop "$REPO_PATH"
else
	msg_info "Repository already exists. Fetching changes."
	cd "$REPO_PATH" && git pull
fi

mkdir -p $HOME/.config/slop
for file in ~/.repos/dotfiles_repos/slop/shaderexamples/*; do
	[ ! -L "$CONF_DIR/${file:t}" ] && {
		msg_info "creating symlink for $CONF_DIR/${file:t}."
		ln -s "$file" "$CONF_DIR"
		continue
	}
	msg_info "$CONF_DIR/${file:t} already exists."
done
