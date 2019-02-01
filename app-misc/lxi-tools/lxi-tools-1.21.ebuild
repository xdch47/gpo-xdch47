# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tools that enables control of LXI compatible instruments"
HOMEPAGE="https://github.com/lxi-tools/lxi-tools"
SRC_URI="https://github.com/lxi-tools/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi qt5"

DEPEND="
	dev-lang/lua:=
	dev-libs/liblxi[avahi=]
	qt5? ( dev-qt/qtcharts )
	"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}"/lxi-gui-gcc-6.patch
	default
	./autogen.sh || die
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--with-bash-completion-dir=no \
		$(use_enable qt5 lxi-gui)
}
