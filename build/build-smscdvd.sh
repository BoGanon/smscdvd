#!/bin/sh

# Trying to generalize it a bit so I don't need to modify it all that much
# per package

# Custom variables
_PKGNAME="cross-ps2-smscdvd"
_GITROOT=https://github.com/ragnarok2040/smscdvd.git
_GITNAME=smscdvd
_GITBRANCH=master

# Various handy variables
_TOPDIR="${PWD}"
_SRCDIR="${PWD}/src"
_PKGDIR="${PWD}/${_PKGNAME}"

echo "\033[01;36mDownloading sources...\033[00m"
if [ -d "${_GITNAME}" ]; then
	echo "Found existing copy..."
	echo "Updating..."
	cd "${_GITNAME}"
	git checkout "${_GITBRANCH}"
	# In case of a rebase of the current commit
	# git reset --hard HEAD~1
	git pull
else
	echo "${_GITNAME} not found."
	echo "Checking out fresh copy..."
	git clone "${_GITROOT}"
	cd "${_GITNAME}"
	git checkout "${_GITBRANCH}"
fi

echo "\033[01;36mChecking for source directory...\033[00m"
if [ -d "${_SRCDIR}" ]; then
	echo "${_SRCDIR} found."
	echo "Removing..."
	rm -r "${_SRCDIR}"
else
	echo "${_SRCDIR} not found."

fi

echo "\033[01;36mChecking for package directory...\033[00m"
if [ -d "${_PKGDIR}" ]; then
	echo "${_PKGDIR} found."
	echo "Removing..."
	rm -r "${_PKGDIR}"
else
	echo "${_PKGDIR} not found."
fi

echo "Making directories..."
mkdir "${_SRCDIR}"
mkdir "${_PKGDIR}"

echo "\033[01;36mExtracting sources to directory...\033[00m"
git checkout-index --prefix="${_SRCDIR}/${_GITNAME}/" -a

# Put in the custom commands for building and packaging
echo "\033[01;36mBuilding package...\033[00m"

if [ -f /etc/profile.d/ps2dev.sh ]; then
	. /etc/profile.d/ps2dev.sh
else
	exit 0
fi

cd "${_SRCDIR}/${_GITNAME}"

make || return 1
make DESTDIR=${_PKGDIR} install || return 1
make clean

# End putting custom commands
echo "\033[01;36mInstalling DEBIAN package files...\033[00m"
install -m755 -d ${_PKGDIR}/DEBIAN
cp -r ${_TOPDIR}/DEBIAN/ ${_PKGDIR}

echo "\033[01;36mCreating DEBIAN package...\033[00m"
cd ${_TOPDIR}
dpkg-deb -z8 -Zgzip --build ${_PKGNAME}

exit 0

