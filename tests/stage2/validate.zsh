#!/usr/bin/env zsh
cd "$HOME" || exit
echo > /scriptout.txt
tail -f /scriptout.txt &

echo "========================================="
xvfb-run -n 99 \
	--server-args="-screen 0 1360x768x16" \
	--auth-file ~/.Xauthority \
	xterm -e "/validate2.zsh | tee /scriptout.txt" #&

echo "========================================="

perceptualdiff -verbose -threshold 25000 neofetch1.png /validate.png
exit $?
