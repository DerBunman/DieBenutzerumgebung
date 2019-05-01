autoload -U colors && colors
# color definition for use with print -P
QUESTION=%B%F{cyan}QUESTION:%f%b
WARNING=%B%F{yellow}WARNING:%f%b
ERROR=%B%F{red}ERROR:%f%b
INFO=%B%F{green}INFO:%f%b

function yesno() {
	print -P "${QUESTION} %{$fg_bold[white]%}${@}${reset_color} [y/N]"
	read -q || {
		print "\r"
		return 1
	}
	print "\r"
	return 0
}

function msg_info() {
	print -P "${INFO} ${@}"
}

function msg_warning() {
	print -P "${WARNING} ${@}"
}

function msg_error() {
	print -P "${ERROR} ${@}"
}
