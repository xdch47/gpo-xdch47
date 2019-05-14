# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="TbSync"
DAV_PV="0.15"
EAS_PV="0.12"

DESCRIPTION="Central user interface to synchronize organisation data with Thunderbird"
HOMEPAGE="https://github.com/jobisoft/TbSync"
SRC_URI="https://github.com/jobisoft/TbSync/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/jobisoft/DAV-4-TbSync/archive/v0.15.tar.gz -> dav4tbsync.tar.gz
	https://github.com/jobisoft/EAS-4-TbSync/archive/v0.12.tar.gz -> eas4tbsync.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dav +eas"

DEPEND="app-arch/zip"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

tbsync_emid="tbsync@jobisoft.de"
dav4tbsync_emid="dav4tbsync@jobisoft.de"
eas4tbsync_emid="eas4tbsync@jobisoft.de"

xpi_files=(content locale skin chrome.manifest install.rdf bootstrap.js LICENSE README.md)

src_compile() {
	zip -r "$S/${tbsync_emid}.xpi" ${xpi_files[@]}

	if use dav ; then
		cd "${WORKDIR}/DAV-4-${MY_PN}-${DAV_PV}"
		zip -r "$S/${dav4tbsync_emid}.xpi" ${xpi_files[@]}
	fi

	if use eas ; then
		cd "${WORKDIR}/EAS-4-${MY_PN}-${EAS_PV}"
		zip -r "$S/${eas4tbsync_emid}.xpi" ${xpi_files[@]}
	fi
}

src_install() {
	insinto "/usr/share/mozilla/extensions/{3550f703-e582-4d05-9a08-453d09bdfdc6}"
	doins "${tbsync_emid}.xpi"
	use dav && doins "${dav4tbsync_emid}.xpi"
	use eas && doins "${eas4tbsync_emid}.xpi"
}
