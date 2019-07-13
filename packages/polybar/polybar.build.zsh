repository="polybar/polybar"
pkg_name="${repository:t}"
tag="3.3.1"
install_debs=(
	polybar_${tag}_amd64.deb
)

noscroll_title "Building ${pkg_name}-${tag}"

noscroll_cmd "git clone"
git clone \
	--recurse-submodules \
	"https://github.com/${repository}" "${build_path}/git"

cd "${build_path}/git"
tar xf $pkg_path/debian.tar.xz

# switch to release tag
git checkout "$tag"

# generate complete changelog
noscroll_cmd "generate complete changelog"
git_changelog "$pkg_name"

# install build debs
noscroll_cmd "installing build dependencies"
sudo mk-build-deps \
	-i \
	-t "apt-get -o Debug::pkgProblemResolver=yes --yes --no-install-recommends"

# build package
noscroll_cmd "compile and build $install_debs"
dpkg-buildpackage -rfakeroot -uc -b

# remove build deps
noscroll_cmd "uninstalling build dependencies"
sudo apt-get --yes purge --auto-remove polybar-build-deps

# move debs to debs dir
for deb in $install_debs; do
	echo test -f ../$deb
	ls ../$deb
	mv -v ../$deb "$debs_path"
done
