# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Library for HMAC-based (HOTP) and time-based (TOTP) passwords"
HOMEPAGE="https://github.com/tadeck/onetimepass"
SRC_URI="https://github.com/tadeck/onetimepass/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

python_install_all() {
	distutils-r1_python_install_all
	dobin "${FILESDIR}/gauth-token"
}
