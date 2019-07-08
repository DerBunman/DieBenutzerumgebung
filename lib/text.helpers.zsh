text_unterlined() {
	local text="$1"
	echo "$text\n${(r:${#text}::=:)${}}\n"
}

text_break() {
	local text="$1"
	
}

## Print a horizontal rule
text_rule () {
	printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${1--}}
}

## Print horizontal ruler with message
text_rulem ()  {
	if [ $# -eq 0 ]; then
		echo "Usage: rulem MESSAGE [RULE_CHARACTER]"
		return 1
	fi
	# Fill line with ruler character ($2, default "-"), reset cursor, move 2 cols right, print message
	printf -v _hr "%*s" $(tput cols) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}

text_right() {
	printf '%*s' $(tput cols) "$*"
}
