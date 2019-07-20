#!/usr/bin/env zsh
cd "$HOME" || exit
echo > /scriptout.txt
#tail -f /scriptout.txt &

pkill -9 -i xvfb
sleep 1

echo "========================================="
#xvfb-run -n 99 \
xvfb-run \
	--server-args="-screen 0 1360x768x16" \
	--auth-file ~/.Xauthority \
	xterm -e "xrdb -load ~/.Xresources; /validate2.zsh > /scriptout.txt" #&

echo "========================================="

cat /scriptout.txt
echo "========================================="

#perceptualdiff -verbose -threshold 25000 neofetch1.png /validate.png
#exit $?
