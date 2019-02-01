# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="amd64 ~x86"

DESCRIPTION="rpc protocol for communicating with vxi11-enabled devices"
HOMEPAGE="https://github.com/applied-optics/vxi11"
SRC_URI="https://github.com/applied-optics/vxi11/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"

DEPEND="net-libs/libtirpc
	net-libs/rpcsvc-proto
"

RDEPEND="$DEPEND"

PATCHES=(
	"${FILESDIR}"/vxi11_send.patch
)

src_compile() {
	emake \
		CFLAGS="${CFLAGS} $(pkg-config --cflags libtirpc) -I$S/library" \
		LDFLAGS="${LDFLAGS} $(pkg-config --libs libtirpc)"
}

src_install() {
	case $ARCH in
		amd64)
			LIB_SUFFIX=64
			;;
		x86)
			LIB_SUFFIX=32
			;;
	esac

	make prefix="${ED%/}"/usr LIB_SUFFIX=${LIB_SUFFIX} install
}
