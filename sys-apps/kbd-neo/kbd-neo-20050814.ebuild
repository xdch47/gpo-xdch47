# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Neo keyboard layout for linux console"
HOMEPAGE="https://neo-layout.org/"
SRC_URI="https://raw.githubusercontent.com/neo-layout/neo-layout/e05614cf8c473f99cca5907267c2f6e5d397c59b/linux/console/neo.map -> kbd-neo.map"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="app-arch/gzip"

S="${WORKDIR}"

src_unpack() {
	ln -s "${DISTDIR}/$A"
}

src_install() {
	dodir /usr/share/keymaps/i386/
	gzip -c kbd-neo.map > "${ED}/usr/share/keymaps/i386/neo.map.gz"
}
