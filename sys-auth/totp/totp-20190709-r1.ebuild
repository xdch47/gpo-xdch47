# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit python-r1 git-r3

EGIT_REPO_URI="https://github.com/TestudoAquatilis/totp"
EGIT_COMMIT="be99541a699552e5fbf9b9c92a109fceba357425"

DESCRIPTION="Command-line time-based one-time-password (TOTP) token generator"
HOMEPAGE="https://github.com/TestudoAquatilis/totp"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DOC="README.md"

RDEPEND="${PYTHON_DEPS}
	dev-python/onetimepass[${PYTHON_USEDEP}]
	app-crypt/gnupg"

src_install() {
	python_foreach_impl python_doscript "${PN}"
	insinto /usr/share
	doins -r zsh
	einstalldocs
}
