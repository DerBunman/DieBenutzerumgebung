(( $+commands[figlet] )) \
	&& FIGLET=(
		"${commands[figlet]}"
		"-f"
		"${0:A:h}/../_assets/figlet_fonts/doom.flf"
	) \
	|| FIGLET=( "figlet_fallback" )

figlet_fallback() {
	local text="$*"
	echo "*** ${(r:${#text}::=:)${}}"
	echo "*** $text"
	echo "*** ${(r:${#text}::=:)${}}\n"
}

text_figlet() {
	$FIGLET "$*"
}

text_underlined() {
	local text="$*"
	echo "$text\n${(r:$((${#text} +1))::=:)${}}\n"
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


# tput commands:
# https://www.gnu.org/software/termutils/manual/termutils-2.0/html_chapter/tput_1.html
# example at 38sed:
# https://streamable.com/za9ul
set_nonscrolling_line() {
	tput init
	tput csr "4" "$((LINES-1))"
	tput clear
	tput smso
	tput bold
	# 1st row is empty
	echo "${(r:${COLUMNS}:: :)${}}"
	local text=" ${1}"
	echo "${(r:${COLUMNS}:: :)${text}}"
	tput sgr0 # disable all attributes
	tput smso
	local text=" ${2}"
	echo "${(r:${COLUMNS}:: :)${text}}"
	echo "${(r:${COLUMNS}:: :)${}}"
	tput rmso
}

update_nonscrolling_line() {
	tput sc
	tput cup $(( 0 + $1 )) 0
	local text="$2"
	text="${(r:${COLUMNS}:: :)${2}}"
	tput smso
	[ "$1" -eq 1 ] && tput bold
	echo "$text"
	tput sgr0 # disable all attributes
	tput rmso
	tput rc
}

reset_scrolling() {
	get_size
	tput sc
	tput csr 0 $(($LINES - 1))
	tput rc
}
