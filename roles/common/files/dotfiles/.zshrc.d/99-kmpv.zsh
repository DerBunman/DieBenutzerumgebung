#!/usr/bin/env zsh
kmpv() { cat "$1" | ssh -t 192.168.178.95 -l khadas "DISPLAY=:0.0 mpv -fs --msg-level all=warn -cache 10024 --force-seekable=yes -" }  

