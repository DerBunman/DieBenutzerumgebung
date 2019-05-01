#!/usr/bin/env zsh
# DOTFILES_INFO: this script just runs 'fc-cache ~/.local/share/fonts'
# DOTFILES_FORCE_RUN
# DOTFILES_RUN_ACTIONS: init, update

msg_info "rebuilding font cache"
fc-cache ~/.local/share/fonts

msg_info "reloading ~/.Xresources"
xrdb ~/.Xresources
