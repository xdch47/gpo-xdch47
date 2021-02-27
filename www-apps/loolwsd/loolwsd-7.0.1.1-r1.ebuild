# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib fcaps

DESCRIPTION="Online is a server service"

HOMEPAGE="https://www.libreoffice.org/download/libreoffice-online/"
SRC_URI="https://dev-www.libreoffice.org/online/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/lool
	acct-user/lool
	>=app-office/libreoffice-$(ver_cut 1)
	>=dev-libs/poco-1.10
	app-arch/cpio"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/polib
	net-libs/nodejs
	dev-util/cppunit"

PATCHES=("${FILESDIR}/0001-loolconfig-adjust-path-for-systemplate.patch")

src_configure() {
	econf \
		--with-lo-path="${EPREFIX}/usr/$(get_libdir)/libreoffice" \
		--with-lokit-path="${EPREFIX}/usr/include/LibreOfficeKit" \
		--with-logfile="${EPREFIX}/var/log/loolwsd/loolwsd.log" \
		--with-vendor="gentoo overlay - xdch47" \
		--with-info-url="https://github.com/xdch47/gpo-xdch47/tree/master/www-apps/${PN}" \
		--with-max-connections 20 \
		--with-max-documents 10 \
		--disable-setcap \
		--disable-werror \
		--enable-anonymization
}

src_install() {
	default

	newinitd "${FILESDIR}/loolwsd.initd" loolwsd

	diropts -m0750 -o lool -g lool
	keepdir {/var/log,/var/lib}/loolwsd
}

pkg_postinst() {
	fcaps cap_fowner,cap_mknod,cap_sys_chroot+ep "${EROOT}/usr/bin/loolforkit"
}
