# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Multithreaded GTK application for rendering the mandelbrot and julia-set"
HOMEPAGE="ihttps://sourceforge.net/projects/mandelbrot-gtk/"
SRC_URI="https://github.com/xdch47/mandelbrot-gtk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:3
	dev-libs/libxml2"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	emake DESTDIR="${ED}" install
	mv "${ED}/usr/share/doc/${PN}" "${ED}/usr/share/doc/${P}"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
