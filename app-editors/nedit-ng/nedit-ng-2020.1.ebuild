# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Qt port of the Nirvana Editor (NEdit)"
HOMEPAGE="https://github.com/eteran/nedit-ng"
SRC_URI="https://github.com/eteran/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui"
BDEPEND="dev-libs/boost"

PATCHES=( "${FILESDIR}"/fix-qpainterpath-inc.patch )
CMAKE_VERBOSE=1

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/applications
	doins "${FILESDIR}"/nedit-ng.desktop

	insinto /usr/share/icons/hicolor/48x48/apps
	doins src/res/nedit-ng.png
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
