api="https://api.github.com/"
repository="davatorium/rofi"
pkg_name="${repository:t}"
tag="1.5.4"
install_debs=(
	rofi_${tag}_amd64.deb
	rofi-dev_${tag}_amd64.deb
)

#wget \
#	"http://deb.debian.org/debian/pool/main/r/rofi/rofi_1.5.1-1.debian.tar.xz" \
#	-O "${build_path}/debian.tar.xz"

git clone \
	--recurse-submodules \
	"https://github.com/${repository}" "${build_path}/git"

cd "${build_path}/git"
tar xf $pkg_path/debian.tar.xz
#tar xf ../debian.tar.xz

# switch to release tag
git checkout "$tag"

# generate complete changelog
git_changelog "$pkg_name"

# install build debs
sudo mk-build-deps -i

# build package
dpkg-buildpackage -rfakeroot -uc -b

# remove build deps
sudo apt-get purge --auto-remove rofi-build-deps

# move debs to debs dir
for deb in $install_debs; do
	echo test -f ../$deb
	ls ../$deb
	mv -v ../$deb "$debs_path"
done
