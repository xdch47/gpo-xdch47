# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
