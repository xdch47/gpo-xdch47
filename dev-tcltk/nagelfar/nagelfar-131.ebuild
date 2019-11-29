# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="a static syntax checker for Tcl"
HOMEPAGE="ihttps://sourceforge.net/projects/nagelfar/files/"
EGIT_REPO_URI="https://git.code.sf.net/p/nagelfar/code"
EGIT_COMMIT="cf6630a8d41c8a9148f67241cf34c3df540cf277"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="" # doc should not be optional: it is used by nagelfar

DEPEND=""
RDEPEND=">=dev-lang/tcl-8.5
	>=dev-lang/tk-8.5"

src_prepare() {
	sed -e "s|@GENTOO_PORTAGE_EPREFIX@|${EPREFIX}|g" \
		-e "s|@GENTOO_PORTAGE_PV@|${PV}|g" \
		"${FILESDIR}"/gentoo_prologue.tcl > src/gentoo_prologue.tcl
	default
}

src_compile() {
	cat src/{gentoo_prologue,nagelfar,gui,dbbrowser,registry,preferences,plugin,startup}.tcl > ${PN}.tcl
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
