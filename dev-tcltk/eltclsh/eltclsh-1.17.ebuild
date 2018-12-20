# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Interactive shell for the TCL programming language"
HOMEPAGE="http://homepages.laas.fr/mallet/soft/shell/eltclsh"
SRC_URI="http://distfiles.openrobots.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="static"

DEPEND="dev-lang/tcl:0= dev-libs/libedit dev-lang/tk "

src_configure() {
	econf \
		$(use_enable static)
}
