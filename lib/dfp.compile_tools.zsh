git_changelog() {
	prevtag=initial
	pkgname="$1"
	git tag -l "*" | sort -V | while read tag; do
		[ "$prevtag" = "initial" ] && {
			prevtag="$tag"
			continue
		}

		{
			echo "$pkgname (${tag}) unstable; urgency=low\n";
			git log --pretty=format:'  * %s' $prevtag..$tag;
			git log --pretty='format:%n%n -- %aN <%aE>  %aD%n%n' $tag^..$tag
		}  | cat - debian/changelog | sponge debian/changelog
	done
}

noscroll_title() {
	update_nonscrolling_line 1 " $1"
}
noscroll_cmd() {
	update_nonscrolling_line 2 " » $1"
}
build_deb() {
	date=$(date +%Y-%m-%d_%H-%M-%S)

	debs_path=${ZSH_ARGZERO:h:A}/../debs/$1
	pkg_path="${ZSH_ARGZERO:h:A}/../packages/$1/"
	build_script="$pkg_path/$1.build.zsh"
	build_path="${ZSH_ARGZERO:h:A}/../tmp/$1/$date"

	test -f "$build_script" || {
		echo "ERROR: $build_script does not exist"
	}
	

	timer=${timer:-$SECONDS}

	# initialize noscroll
	set_nonscrolling_line " Building ${1} ..." " » ... "

	echo "Creating debs dir ..."
	mkdir -p "$debs_path"
	echo "Creating and changing to $build_path ..."
	mkdir -p "$build_path"
	cd "$build_path"
	echo "Starting build script $build_script ..."
	setopt ERR_EXIT
	. "$build_script" || {
		echo "ERROR while building"
		exit 1
	}  2>&1 | tee log.txt

	echo "Build finished, installing debs:"
	for file in $install_debs; do
		noscroll_cmd "installing $file"
		sudo dpkg -i ${debs_path:A}/${file} \
			|| sudo apt-get -f install
	done

	echo "Runtime in $(($SECONDS - $timer))sec"

	reset_scrolling
}
