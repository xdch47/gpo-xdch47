# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="intelligent typing tutor"
HOMEPAGE="https://gitlab.com/tipp10/tipp10"
SRC_URI="https://gitlab.com/tipp10/tipp10/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtmultimedia
	dev-qt/qtprintsupport
	dev-qt/qtsql"

S="${WORKDIR}/${PN}-v${PV}"

pkg_postinst() {
	xdg_icon_cache_update
}
pkg_postrm() {
	xdg_icon_cache_update
}
