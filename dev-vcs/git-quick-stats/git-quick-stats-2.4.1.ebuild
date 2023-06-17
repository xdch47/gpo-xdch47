# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple and efficient way to access various statistics in a git repository"
HOMEPAGE="https://github.com/arzzen/git-quick-stats"
SRC_URI="https://github.com/arzzen/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-vcs/git
	sys-apps/coreutils
	app-alternatives/awk

"
BDEPEND=""

src_compile() {
	:
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
}
