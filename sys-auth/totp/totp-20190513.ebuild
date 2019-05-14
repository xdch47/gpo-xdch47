# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3
EGIT_REPO_URI="https://github.com/TestudoAquatilis/totp"
EGIT_COMMIT="ba17832de9e82e2b1c9550f24c56fdfed38a5187"

DESCRIPTION="Command-line time-based one-time-password (TOTP) token generator"
HOMEPAGE="https://github.com/TestudoAquatilis/totp"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DOC=(README.md)

COMMON_DEPEND=(
	dev-python/onetimepass
	app-crypt/gnupg
	)
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_install() {
	einstalldocs
	dobin  totp
	insinto /usr/share
	doins -r zsh
}
