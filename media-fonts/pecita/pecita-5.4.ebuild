# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A typeface that mimics handwriting"
HOMEPAGE="http://pecita.eu"
SRC_URI="http://pecita.eu/b/Pecita.otf -> ${PN}.otf"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/fontconfig"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${PN}.otf" "$S"
}

src_install() {
	insinto /usr/share/fonts/OTF
	doins ${PN}.otf
}
