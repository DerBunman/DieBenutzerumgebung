#!/usr/bin/env sh
if [ "$1" = "" ]; then
	DIR="$(realpath .)"
	echo "No path provided. Using current directory."
else
	DIR="$(realpath "$1")"
fi

echo "Starting httpd for '$DIR'"
python3 -m http.server -d "$DIR"
