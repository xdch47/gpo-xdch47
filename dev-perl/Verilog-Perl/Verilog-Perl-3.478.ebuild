# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="WSNYDER"
DIST_VERSION=${PV}
inherit perl-module

DESCRIPTION="Perl parsing and utilities for the Verilog Language"

LICENSE="|| ( Artistic-2 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_compile() {
	# Force linking against -lstdc++
	emake OTHERLDFLAGS="-Wl,-rpath "$EPREFIX/usr/$(get_libdir)" -lstdc++"
}
