# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Microsoft Teams, an Office 365 multimedia collaboration client, pre-release"
HOMEPAGE="https://teams.microsoft.com/downloads#allDevicesSection"
SRC_URI="teams_1.3.00.5153_amd64.deb"

LICENSE="ms-teams-pre"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="fetch mirror splitdebug"
IUSE=""

QA_PREBUILT="*"

RDEPEND="
	app-accessibility/at-spi2-atk
	app-crypt/libsecret
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gnome-keyring
	media-libs/alsa-lib
	media-libs/fontconfig
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
"

src_unpack() {
	default
	mkdir "${S}" || die
	cd "${S}" || die
	unpack ../data.tar.xz
}

src_install() {
	mv -v "${S}/"* "${ED}/" || die
}
