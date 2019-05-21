#!/usr/bin/env zsh
urls=(
	'https://easylist-downloads.adblockplus.org/easylistgermany+easylist.txt'
	'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblockplus'
	'https://easylist.to/easylist/easyprivacy.txt'
	'https://easylist.to/easylist/fanboy-annoyance.txt'
)

target_dir=~/.local/share/luakit/adblock

for url in $urls; do
	filename="$(echo $url \
		| sed -e 's/[^A-Za-z0-9._-]/_/g').txt"

	tmp_file=$(mktemp)
	wget "$url" -O "$tmp_file" || {
		echo "Error fetching $url ..."
		continue
	}
	echo "Copying $url to $target_dir/$filename"
	mv "$tmp_file" "$target_dir/$filename"
done
