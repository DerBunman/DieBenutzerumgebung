#!/usr/bin/env zsh
xrdb -load ~/.Xresources
for dir in ~/.repos/dotfiles/packages/*; do
	~/.repos/dotfiles/dotfiles dfp install $dir:t && { \
		echo "GOOD DFP $dir"
	} || { \
		echo "ERROR IN DFP $dir"
		continue
	}
	xrdb -load ~/.Xresources
done
