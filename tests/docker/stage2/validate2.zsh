#!/usr/bin/env zsh
echo starting i3 >> /scriptout.txt
# hide x6erm
xdotool windowunmap $(xdotool search --classname "xterm")

{
	sleep 240
	pkill -i -9 xvfb
} &

# start i3 as background process
i3 &
# give it a few seconds to startr
sleep 5
# trigger i3 restart, so xrdb gets applied
i3-msg restart
# start xterm with neofetch as bg process
urxvt -e zsh -c "neofetch; sleep 120" &
# restart i3 (just to be sure)
i3-msg restart
# give urxvt a few seconds
sleep 5
# create screenshot and upload to doublefun
img=neofetch1.png;
scrot $img;
echo taking screenshot
curl -s -X POST -F "image=@$img" https://doublefun.net/media/x.php
# kill i3 and urxvt to leave xvfb graceful
pkill i3
pkill urxvt
pkill -9 -i xvfb
# the screenshot will be taken in validate.zsh
# when this script ends
