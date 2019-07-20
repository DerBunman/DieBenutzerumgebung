# Pull base image.
FROM ubuntu:disco
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
# Install locales
	apt-get install -y apt-utils locales && \
# Set locale
	sed --in-place '/en_US.UTF-8/s/^# //' /etc/locale.gen && \
	locale-gen && \
# Set system locale (add line)
	echo "export LANG=en_US.UTF-8" >> /etc/profile && \
# Set system timezone (add line)
	echo "export TZ=UTC" >> /etc/profile

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get install -y build-essential && \
	apt-get install -y software-properties-common && \
	apt-get install -y sudo locales xvfb curl git htop man unzip vim wget zsh xterm scrot libnotify-bin python && \
	locale-gen en_US en_US.UTF-8 && \
	apt-get install -y --ignore-missing procps python moreutils build-essential fakeroot devscripts dpkg-dev equivs curl wget powerline tmux mc ranger detox pv figlet net-tools apt-file sysfsutils p7zip-full unp unzip grc silversearcher-ag shellcheck pass xbindkeys xbindkeys-config xdotool x11-xserver-utils compton arandr fonts-roboto fonts-roboto-hinted xclip slop aosd-cat compton libnotify-bin zathura-cb zathura zathura-djvu zathura-pdf-poppler zathura-ps pavucontrol arandr udiskie feh xclip lxappearance xscreensaver-screensaver-webcollage xscreensaver xscreensaver-screensaver-bsod xscreensaver-gl-extra xscreensaver-gl xscreensaver-data-extra rxvt-unicode-256color i3 golang-go libxtst-dev vim exuberant-ctags vim-gtk3 perceptualdiff apt-utils neofetch

RUN \
  git clone --recursive https://github.com/DerBunman/DieBenutzerumgebung ~/.repos/dotfiles

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# enable all host flags
RUN mkdir -p ~/.config/dotfiles/dotfiles/host_flags/ \
	&& echo "has_x11 has_root install_packages assume_yes" > \
	~/.config/dotfiles/dotfiles/host_flags/checked

# start install script in xterm in xvfb
RUN xvfb-run -a -e /dev/stdout \
	xterm -e zsh -c "~/.repos/dotfiles/dotfiles dfp install polybar"

RUN pkill -9 -i xvfb; sleep 2

# start install script in xterm in xvfb
RUN xvfb-run -a -e /dev/stdout \
	xterm -e zsh -c "~/.repos/dotfiles/dotfiles dfp install rofi"

ARG CACHEBUST=1
RUN echo $CACHEBUST

ADD build.sh /
ADD install.zsh /
ADD validate.zsh /
ADD validate2.zsh /
ADD validate.disco.png /validate.png

RUN /bin/zsh -c "\
	chmod 755 /build.sh && /build.sh \
	&& ls -l / && chmod 755 /validate2.zsh /validate.zsh && /bin/zsh -c /validate.zsh \
	&& perceptualdiff -verbose -threshold 25000 /neofetch1.png /validate.png"
