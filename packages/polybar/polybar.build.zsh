repository="polybar/polybar"
pkg_name="${repository:t}"
tag="3.3.1"
install_debs=(
	rofi_${tag}_amd64.deb
	rofi-dev_${tag}_amd64.deb
)

git clone \
	--recurse-submodules \
	"https://github.com/${repository}" "${build_path}/git"

cd "${build_path}/git"
#cp -Rv $pkg_path/debian .
tar xf $pkg_path/debian.tar.xz

# switch to release tag
git checkout "$tag"

# generate complete changelog
git_changelog "$pkg_name"

# install build debs
sudo mk-build-deps -i

# build package
dpkg-buildpackage -rfakeroot -uc -b

# remove build deps
sudo apt-get purge --auto-remove polybar-build-deps

# move debs to debs dir
for deb in $install_debs; do
	echo test -f ../$deb
	ls ../$deb
	mv -v ../$deb "$debs_path"
done
