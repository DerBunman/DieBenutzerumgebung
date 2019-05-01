#!/usr/bin/env zsh
#       _                            _
# __  _| | _____ _   _ ___   _______| |__
# \ \/ / |/ / _ \ | | / __| |_  / __| '_ \
#  >  <|   <  __/ |_| \__ \_ / /\__ \ | | |
# /_/\_\_|\_\___|\__, |___(_)___|___/_| |_|
#                |___/

last_class="none"
current_map=default

#xmodmap -pke > "${HOME}/.xkeys/default.xmodmap"

msg_info = function() {
	prefix="[$(date +%H:%M:%S)]"
	echo "${prefix} $*"
	false && notify-send \
		--expire-time 800 \
		-i ~/.icons/xkeys.svg \
		"${prefix} $*"
}

# load default map
current_map="default"
tmp="$(mktemp)"
restore="$(mktemp)"
xmodmap -pke > $tmp
diff "${HOME}/.xkeys/default.xmodmap" "${tmp}" \
	| grep '<' \
	| tr '<' ' ' \
	> "$restore"
xmodmap "$restore"

xprop -spy -root _NET_ACTIVE_WINDOW | while read line; do
	class="$(xprop WM_CLASS -id ${line##* } | cut -d= -f2 | sed 's/[" ]//g' | sed 's/^.*,//')"
	echo "[$(date +%H:%M:%S)] Class: ${class}"
	if [ "${class}" != "${last_class}" ]; then
		last_class="${class}"

		#       _     _           _ _
		# __  _| |__ (_)_ __   __| | | _____ _   _ ___
		# \ \/ / '_ \| | '_ \ / _` | |/ / _ \ | | / __|
		#  >  <| |_) | | | | | (_| |   <  __/ |_| \__ \
		# /_/\_\_.__/|_|_| |_|\__,_|_|\_\___|\__, |___/
		#                                    |___/
		# handling the processes via background jobs
		# gives us the possibility to easily kill
		# the processes without touching other
		# xbindkeys instances
		if [ ${#jobstates} -gt 1 ]; then
			for job in $jobstates; do
				pid=$(echo $job | grep -o "[0-9]*")
				ps $pid | grep xbindkeys >/dev/null
				[ $? -ne 0 ] && {
					#msg_info "skipping job #$(ps $pid)"
					continue
				}
				kill $pid
				msg_info "Killed xbindkeys job #${pid}"
			done
		fi

		file="${HOME}/.xkeys/${class:l}.xbindkeys"
		if [ -f "$file" ]; then
			msg_info "Set xbindkeys: ${file}"

			xbindkeys -f "$file" --show \
				| sed 's/^/              /'
			# the --nodaemon is crucial for
			# the job managment
			xbindkeys -f "$file" --nodaemon &
		fi

		#                           _
		# __  ___ __ ___   ___   __| |_ __ ___   __ _ _ __
		# \ \/ / '_ ` _ \ / _ \ / _` | '_ ` _ \ / _` | '_ \
		#  >  <| | | | | | (_) | (_| | | | | | | (_| | |_) |
		# /_/\_\_| |_| |_|\___/ \__,_|_| |_| |_|\__,_| .__/
		#                                            |_|
		if [ "${current_map}" != "default" ]; then
			current_map="default"

			tmp="$(mktemp)"
			restore="$(mktemp)"
			xmodmap -pke > $tmp
			diff "${HOME}/.xkeys/default.xmodmap" "${tmp}" \
				| grep '<' \
				| tr '<' ' ' \
				> "$restore"
			xmodmap "$restore"

			msg_info "Restored default keymap."
		fi

		file="${HOME}/.xkeys/${class:l}.xmodmap"
		if [ -f "$file" ]; then
			msg_info "Set xmodmap: ${file}"

			xmodmap "$file"

			current_map=${class:l}
		fi
	fi
done
