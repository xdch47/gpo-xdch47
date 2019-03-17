# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple btrfs snapshot helper"
HOMEPAGE="https://github.com/xdch47/btrsnapshot"
SRC_URI="https://github.com/xdch47/btrsnapshot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	# do not run make -- nothing to do
	:
}

src_install() {
	dosbin btrsnapshot
	doman btrsnapshot.1
}
