#!/usr/bin/env zsh
zmodload zsh/parameter
cd "$HOME" || exit

touch /scriptout.txt
{ tail -f /scriptout.txt | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' } &
#git clone --recursive https://github.com/DerBunman/DieBenutzerumgebung ~/.repos/dotfiles

# update the cloned repo. has been checked out in Dockerfile
cd ~/.repos/dotfiles
git pull --recurse-submodules

# when the docker plugin is enabled the build blocks there
sed -i 's/docker//' ~/.repos/dotfiles/packages/zsh/zshrc

# enable all host flags
mkdir -p ~/.config/dotfiles/dotfiles/host_flags/
echo "has_x11 has_root install_packages assume_yes" > \
	~/.config/dotfiles/dotfiles/host_flags/checked

# start install script in xterm in xvfb :)
xvfb-run -n 99 \
	--server-args="-screen 0 1360x768x16" \
	--auth-file ~/.Xauthority \
	xterm -e "/install.zsh | tee /scriptout.txt" #&

