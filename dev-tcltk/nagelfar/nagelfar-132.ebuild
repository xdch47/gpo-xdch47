# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

src_compile() {
	sed -i \
		-e "s|^set dbdir |& ${EPREFIX}/usr/lib/nagelfar|g" \
		-e "s|^set docdir|& ${EPREFIX}/usr/share/doc/nagelfar-${PV}|g" \
		nagelfar.tcl || die
}

src_install() {
	# install script, removing trailing .tcl
	newbin ${PN}.tcl ${PN}

	# install syntax buildscript
	insinto /usr/lib/${PN}
	doins syntaxbuild.tcl

	# install syntax files and packagedb
	doins syntaxdb.tcl
	doins -r packagedb

	# prevent the docs from being compressed, the GUI needs to read them
	docompress -x /usr/share/doc
	DOCS=(doc/*)
	einstalldocs
}
