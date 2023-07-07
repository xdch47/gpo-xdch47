# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P="${PN}-v${PV}"

DESCRIPTION="Gajim omemo crypto library"
HOMEPAGE="https://dev.gajim.org/gajim/omemo-dr"
SRC_URI=" https://dev.gajim.org/gajim/${PN}/-/archive/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

S="${WORKDIR}/${MY_P}"
