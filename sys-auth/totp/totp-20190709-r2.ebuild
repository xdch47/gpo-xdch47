# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} python3_13t )

inherit python-r1 git-r3

EGIT_REPO_URI="https://github.com/TestudoAquatilis/totp"
EGIT_COMMIT="be99541a699552e5fbf9b9c92a109fceba357425"

DESCRIPTION="Command-line time-based one-time-password (TOTP) token generator"
HOMEPAGE="https://github.com/TestudoAquatilis/totp"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

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
