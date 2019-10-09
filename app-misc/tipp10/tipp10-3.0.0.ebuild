# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

DESCRIPTION="intelligent typing tutor"
HOMEPAGE="https://gitlab.com/a_a/tipp10"
SRC_URI="https://gitlab.com/a_a/tipp10/-/archive/v${PV}/tipp10-v${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtmultimedia"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	# Fix FS#63160 - [tipp10] Initial launch fails: database cannot be imported
	sed -i "s#QCoreApplication::applicationDirPath()#QString(\"${EPREFIX}/usr/share/tipp10\")#g" -- $(grep -lFr 'QCoreApplication::applicationDirPath()' .) || die
	# Fix sound file location
	sed -i "s#= new QSound(\"\(error\|metronome\).wav\");#= new QSound(\"${EPREFIX}/usr/share/tipp10/\1.wav\");#" widget/trainingwidget.cpp || die
	# Fix Q/A for desktop-icon
	sed -i -r -e 's/(Icon=tipp10).png/\1/' tipp10.desktop || die
	# Workaround QTBUG-31360 (QSettings with group named general)
	sed -i -e 's#\(settings.beginGroup\s*\)("general");#\1("main");#g' $(grep -lFr 'settings.beginGroup("general");') || die
	default
}

src_configure() {
	eqmake5
}

src_install() {
	dobin  tipp10
	insinto /usr/share/${PN}
	doins release/tipp10v2.template

	insinto /usr/share/pixmaps
	doins tipp10.png

	insinto /usr/share/applications
	doins tipp10.desktop

	insinto /usr/share/tipp10
	doins -r "error.wav" "metronome.wav" release/help
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
