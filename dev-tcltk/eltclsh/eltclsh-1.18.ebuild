# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Interactive shell for the TCL programming language"
HOMEPAGE="https://homepages.laas.fr/mallet/soft/shell/eltclsh"
SRC_URI="http://distfiles.openrobots.org/eltclsh/eltclsh-1.18.tar.gz"

LICENCE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND="dev-lang/tcl:0= dev-libs/libedit dev-lang/tk dev-libs/libedit"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	econf \
		$(use_enable static)
}

src_install() {
	find "${ED}" -name '*.la' -delete || die
}
