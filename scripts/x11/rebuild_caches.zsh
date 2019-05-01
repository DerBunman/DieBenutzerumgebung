#!/usr/bin/env zsh
# DOTFILES_INFO: this script just runs 'fc-cache ~/.local/share/fonts'
# DOTFILES_FORCE_RUN

msg_info "rebuilding font cache"
fc-cache ~/.local/share/fonts

msg_info "reloading ~/.Xresources"
xrdb ~/.Xresources
