# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="GNU readline for interactive tcl shells"
HOMEPAGE="https://github.com/flightaware/tclreadline"
SRC_URI="https://github.com/flightaware/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/tcl:0=
	sys-libs/readline:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"$FILESDIR/alloc-invalid-block.patch"
	)

src_prepare() {
	default

	eautoreconf
}

pkg_postinst() {
	einfo "In order to enable a interactive readline prompt for tclsh"
	einfo "add the following lines to your \$HOME/.tclshrc:"
	einfo "    if {\$tcl_interactive} {"
	einfo "        package require tclreadline"
	einfo "        ::tclreadline::Loop"
	einfo "    }"
}
