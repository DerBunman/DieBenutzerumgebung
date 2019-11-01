#!/usr/bin/env zsh
echo $0 | figlet
gsettings set org.blueman.general notification-daemon false
~/bin/i3-applet-wrapper nm-applet &!
~/bin/i3-applet-wrapper blueman-applet &!
KILL_CMD="pkill indicator" ~/bin/i3-applet-wrapper indicator-cpufreq &!

pgrep --full usbguard-applet-qt
killall usbguard-applet-qt
sleep 2
pgrep --full usbguard-applet-qt || usbguard-applet-qt &!
