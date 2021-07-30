# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tcl-Library for scripted HDL generation "
HOMEPAGE="https://icglue.org/"

case ${PV} in
	*_alpha*)
		MY_PV="${PV/_alpha/a}"
		;;
	*)
		MY_PV="${PV}"
		;;
esac

SRC_URI="https://github.com/xdch47/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/xdch47/${PN}/releases/download/v${MY_PV}/build-assets.tar.gz -> ${P}-build-assets.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nagelfar system-tcllib"

DEPEND="dev-libs/glib
	nagelfar? ( dev-tcltk/nagelfar )
	system-tcllib? ( dev-tcltk/tcllib )"

RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	default
	$(use nagelfar) && emake syntaxdb
}

src_install() {
	emake DESTDIR="$D" PREFIX="${EPREFIX}/usr" USE_BUNDLED_TCLLIB=$(usex !system-tcllib YES NO) install
	$(use nagelfar) || rm -f "${ED}/share/vim/syntax_checkers"
}
