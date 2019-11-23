agreplace() {
	if [ $# -ne 2 ]; then
		print "Syntax: $0 'search' 'replace'"
		exit 1
	fi

	ANSI_GREEN='\033[32;32m'
	ANSI_RED='\033[31;31m'
	ANSI_RESET='\033[0;0m'

	for file in $(ag --files-with-matches "$1"); do
		print "================================="
		print "=> ${file}"
		print "================================="
		tmpfile=$(mktemp)
		sed "s/${1}/${2}/" "$file" >! $tmpfile;
		diff "$file" "$tmpfile"
		rm "$tmpfile"

		print "================================="
		read -q "REPLY?Write changes? [y/n]?"

		case "$REPLY" in
		Y*|y*)
			print "\n${ANSI_GREEN}OK, writing changes ..."
			sed "s/${1}/${2}/" "$file" -i
		;;
		N*|n*)
			print "\n${ANSI_RED}OK, skipping ..."
		;;
		esac
		print ${ANSI_RESET}
	done
};
