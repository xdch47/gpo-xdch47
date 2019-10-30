# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg-utils

DESCRIPTION="intelligent typing tutor"
HOMEPAGE="https://gitlab.com/a_a/tipp10"
SRC_URI="https://github.com/xdch47/tipp10/archive/v3.1.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtmultimedia"
RDEPEND="${DEPEND}
	dev-qt/qtsql"
BDEPEND=""
