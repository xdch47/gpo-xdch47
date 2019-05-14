# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="grml's zsh setup"
HOMEPAGE="https://grml.org/zsh/"
SRC_URI="https://deb.grml.org/pool/main/g/grml-etc-core/grml-etc-core_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-shells/zsh
	sys-apps/coreutils
	sys-apps/sed
	sys-apps/grep
	sys-process/procps"

BDEPEND="app-text/txt2tags"

S="${WORKDIR}/grml-etc-core-${PV}"

src_compile() {
	cd doc
	default
}

src_install() {
	insinto /etc/zsh
	doins  etc/zsh/{keephack,zshrc}

	insinto /etc/skel
	doins etc/skel/.zshrc

	doman doc/grmlzshrc.5
}
