#!/usr/bin/env sh

sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y sudo locales xvfb curl git htop man unzip vim wget zsh xterm scrot libnotify-bin python && \
  locale-gen en_US en_US.UTF-8 && \
  apt-get install -y --ignore-missing python moreutils build-essential fakeroot devscripts dpkg-dev equivs curl wget powerline tmux mc ranger detox pv figlet net-tools apt-file sysfsutils p7zip-full unp unzip grc silversearcher-ag shellcheck pass xbindkeys xbindkeys-config xdotool x11-xserver-utils compton arandr fonts-roboto fonts-roboto-hinted xclip slop aosd-cat compton libnotify-bin zathura-cb zathura zathura-djvu zathura-pdf-poppler zathura-ps pavucontrol arandr udiskie feh xclip lxappearance xscreensaver-screensaver-webcollage xscreensaver xscreensaver-screensaver-bsod xscreensaver-gl-extra xscreensaver-gl xscreensaver-data-extra rxvt-unicode-256color i3 golang-go libxtst-dev vim exuberant-ctags vim-gtk3 perceptualdiff apt-utils neofetch && \
  git clone --recursive https://github.com/DerBunman/DieBenutzerumgebung ~/.repos/dotfiles
