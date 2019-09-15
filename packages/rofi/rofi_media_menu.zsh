#!/usr/bin/env zsh
STREAMABLEUSER=false
STREAMABLEPASSWORD=false
FFMPEG_PIDFILE=/tmp/rofimedia.ffmpeg.pid
VIDEO_PATH="$HOME/Videos"
VIDEO_EXT="mp4"

# include local config
test -f ~/.config/rofi_media_menu.zsh \
	&& . ~/.config/rofi_media_menu.zsh

FFMPEG_RUNNING=false
test -f "$FFMPEG_PIDFILE" && {
	[ "$(ps -p $(<"$FFMPEG_PIDFILE") -o comm=)" = "ffmpeg" ] \
		&& FFMPEG_RUNNING=true
}
output="$VIDEO_PATH/screencast.$(date +%Y-%m-%d_%H-%M-%S).$VIDEO_EXT"

streamupload() {
	code=$(curl --ignore-content-length --http1.0 \
		--request POST \
		--url https://api.streamable.com/upload \
		--user "$STREAMABLEUSER:$STREAMABLEPASSWORD" \
		--form file=@$1 -v \
		| jq '.shortcode' --raw-output)
	notify-send -i ~/.icons/screenshot_clipboard.svg \
		"Uploaded video" \
		"Added https://streamable.com/$code to your clipboard"
	echo https://streamable.com/$code | xclip -selection c
}

if [ $# -eq 0 ]; then
	echo -en "\x00prompt\x1fmedia capture\n"
	echo -en "\0markup-rows\x1ftrue\n"
	echo -en "\0message\x1fVideo save path: <b>$output</b>\n"
	echo -en "Upload to streamable.com\0icon\x1fweather-overcast\n"
	echo -en "Screenshot area or window.\0icon\x1fcamera-photo\n"
	if [ $FFMPEG_RUNNING = true ]; then
		echo -en "Stop current recording.\0icon\x1fmedia-playback-stop\n"
	else
		echo -en "Record current display. ($DISPLAY)\0icon\x1fmedia-record\n"
		echo -en "Record selected area.\0icon\x1fmedia-record\n"
	fi
	exit

elif [[ "$1" == "Upload to streamable.com" ]]; then
	#setopt EXTENDED_GLOB
	echo -en "\0active\x1f0\n"
	echo -en "\0message\x1fSelect file that should be uploaded to streamable.com:\n"
	for file in $VIDEO_PATH/*$VIDEO_EXT(om); do
		echo "upload: ${file:t}\0icon\x1fvideo-x-generic"
	done

elif [[ "$1" == $'upload:'* ]]; then
	killall rofi
	#file=$HOME/Videos/screencast*(om[1])
	file=${1:s/upload: /}
	streamupload ${VIDEO_PATH}/$file
	exit

elif [[ "$1" == "Screenshot area or window." ]]; then
	killall rofi

	notify-send -i ~/.icons/screenshot_clipboard.svg "Screenshot" "Please select area."

	[ $+commands[slop] -ne 0 ] \
		&& slop=$(slop -f "%g") \
		&& read -r G < <(echo $slop) \
		&& import -window root -crop $G png:- | xclip -selection c -t image/png \
		&& notify-send -i ~/.icons/screenshot_clipboard.svg \
			"Screenshot (using slop)" \
			"Selection has been copied to clipboard." \
		&& exit 0

	# if slop failed retry without it
	import png:- | xclip -selection c -t image/png \
		&& notify-send -i ~/.icons/screenshot_clipboard.svg \
			"Screenshot (using IM rectangle)" \
			"Selection has been copied to clipboard." \
		&& exit 0

	notify-send -i ~/.icons/status/error.png \
		"Screenshot error" \
		"Error while creating screenshot."
	exit 1

elif [[ "$1" == "Stop current recording." ]]; then
	killall rofi
	xargs -a "$FFMPEG_PIDFILE" kill
	while kill -0 $(<$FFMPEG_PIDFILE) 2> /dev/null; do sleep 1; done;
	file=$HOME/Videos/screencast*(om[1])
	streamupload ${^~file}
	exit


elif [[ "$1" == "Record current display. ($DISPLAY)" ]]; then
	killall rofi
	# record the full screen
	resolution="$(xrandr --current | grep '*' | uniq | awk '{print $1}')"
	ffmpeg -video_size "$resolution" -framerate 25 -f x11grab -i $DISPLAY "$output" &
	echo $! > "$FFMPEG_PIDFILE"
	exit

elif [[ "$1" == "Record selected area." ]]; then
	killall rofi
	notify-send -i ~/.icons/screenshot_clipboard.svg "Record selected area." "Please select area."
	read -d $'\n' -r resolution offset < <(slop -f "%wx%h +%x,%y"; echo "")
	ffmpeg -show_region 1 -video_size "$resolution" -framerate 25 -f x11grab -i "${DISPLAY}${offset}" "$output" &
	echo $! > "$FFMPEG_PIDFILE"
	exit

fi
