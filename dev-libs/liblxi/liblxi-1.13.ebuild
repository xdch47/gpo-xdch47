# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple API for communicating with LXI compatible instruments"
HOMEPAGE="https://lxi-tools.github.io/"
SRC_URI="https://github.com/lxi-tools/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="avahi static-libs"

DEPEND="
	avahi? ( net-dns/avahi )
	dev-libs/libxml2
	"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	./autogen.sh || die
}

src_configure() {
	econf \
		$(use_enable avahi) \
		$(use_enable static-libs static)
}
