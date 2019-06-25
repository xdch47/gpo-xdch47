# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tcl-Library for scripted HDL generation "
HOMEPAGE="https://icglue.org/"
SRC_URI="https://github.com/icglue/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nagelfar"

DEPEND="dev-tcltk/tcllib
	dev-libs/glib
	nagelfar? ( dev-tcltk/nagelfar )"

RDEPEND="${DEPEND}"
BDEPEND="media-gfx/inkscape"

src_compile() {
	default
	$(use nagelfar) && emake syntaxdb
}

src_install() {
	emake DESTDIR="$D" PREFIX="${EPREFIX}/usr" install
	$(use nagelfar) || rm -f "${ED}/share/vim/syntax_checkers"
}
