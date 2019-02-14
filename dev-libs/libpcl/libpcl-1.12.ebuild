# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implements the low level functionality for coroutines"
HOMEPAGE="http://xmailserver.org/libpcl.html"
MY_P="pcl-${PV}"
SRC_URI="http://xmailserver.org/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
