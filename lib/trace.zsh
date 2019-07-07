trace() {
	echo "--------------------------------------------"
	echo "TRACE:"
	echo "------"
	for ((index=1; index <= ${#funcfiletrace[@]}; ++index)); do
		echo "${funcfiletrace[index]} -> ${functrace[index]}"
	done | column -t
	echo "--------------------------------------------"
}
