# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin}"
job="11194583450"

DESCRIPTION="A waveform viewer with a focus on a snappy usable interface, and extensibility."

HOMEPAGE="https://gitlab.com/surfer-project/surfer"
SRC_URI="https://gitlab.com/surfer-project/${MY_PN}/-/jobs/${job}/artifacts/raw/${MY_PN}_linux.zip -> ${P}.zip"

S="${WORKDIR}"
LICENSE="EUPL-1.2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

src_install() {
	dobin surfer
	#dobin surver
}
