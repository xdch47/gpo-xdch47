# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )

DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

DESCRIPTION="Python abstraction layer for registerfile access"
HOMEPAGE="https://github.com/icglue/regfile_generics"
SRC_URI="https://github.com/icglue/regfile_generics/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

BDEPEND="dev-python/hatch-vcs[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
