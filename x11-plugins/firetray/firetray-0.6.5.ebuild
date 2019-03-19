# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="FireTray"

DESCRIPTION="System tray for mozilla thunderbird"
HOMEPAGE="https://github.com/Ximi1970/FireTray"
SRC_URI="https://github.com/Ximi1970/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}/src"

src_prepare() {
	sed -i \
		-e 's/^SCM-REVISION = .*/#&/' \
		-e 's/^build_dir := .*/build_dir := build/' \
		Makefile
	mkdir ./build
	default
}

src_compile() {
	emake build
}

src_install() {
	local emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' build/install.rdf)
	[[ -n ${emid} ]] || die "Could not scrape EM:ID from install.rdf"

	mv build/${P}.xpi build/"${emid}.xpi" || die 'Could not rename XPI to match EM:ID'

	# thunderbird
	insinto "/usr/share/mozilla/extensions/{3550f703-e582-4d05-9a08-453d09bdfdc6}"
	doins build/"${emid}.xpi"
}
