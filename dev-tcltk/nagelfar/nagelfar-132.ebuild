# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Static syntax checker for Tcl"
HOMEPAGE="https://sourceforge.net/projects/nagelfar/files/"
SRC_URI="https://sourceforge.net/projects/nagelfar/files/Rel_${PV}/nagelfar${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="" # doc should not be optional: it is used by nagelfar

DEPEND=""
RDEPEND=">=dev-lang/tcl-8.5
	>=dev-lang/tk-8.5"

PATCHES=("${FILESDIR}/doc-syntaxdatabase.patch")

S="${WORKDIR}/${PN}${PV}"

src_install() {

	# install syntax buildscript
	insinto "/usr/lib/${PN}"
	doins syntaxbuild.tcl

	exeinto "/usr/lib/${PN}"
	doexe "${PN}.tcl"

	dosym -r  "/usr/lib/${PN}/${PN}.tcl" "/usr/bin/${PN}"
	# install syntax files and packagedb
	doins syntaxdb.tcl
	doins -r packagedb

	# prevent the docs from being compressed, the GUI needs to read them
	docompress -x /usr/share/doc
	DOCS=(doc/*)
	einstalldocs
}
