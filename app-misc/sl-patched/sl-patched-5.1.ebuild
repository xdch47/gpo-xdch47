# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Steam Locomotive runs across your terminal; patched long version"

HOMEPAGE="https://github.com/tkw1536/sl-patched"
EGIT_REPO_URI="https://github.com/tkw1536/sl-patched.git"
EGIT_COMMIT="c9e848ad902c6cc4598cfa7e646c90f9630006fe"
LICENSE="Toyoda WTFPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="sys-libs/ncurses:*
	!app-misc/sl"

DEPEND="${RDEPEND}"

src_compile() {
	emake LDFLAGS="$(pkg-config --libs ncurses)"
}

src_install() {
	dobin "sl"
	insinto "/etc/profile.d"
	doins "${FILESDIR}/sl.sh"
}
