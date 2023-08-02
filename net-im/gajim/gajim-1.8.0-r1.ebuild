# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="sqlite,xml(+)"
DISTUTILS_USE_PEP517=standalone
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 xdg-utils

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="https://gajim.org/"
SRC_URI="https://gajim.org/downloads/$(ver_cut 1-2)/${P/_p/-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="geolocation jingle remote rst +spell upnp +webp"

COMMON_DEPEND="
	dev-libs/gobject-introspection[cairo(+)]
	>=x11-libs/gtk+-3.22:3[introspection]
	x11-libs/gtksourceview:4[introspection]"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	virtual/pkgconfig
	>=sys-devel/gettext-0.17-r1"
RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		app-crypt/libsecret[crypt,introspection]
		dev-python/css-parser[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
		>=dev-python/nbxmpp-4.3.0[${PYTHON_USEDEP}]
		<dev-python/nbxmpp-5.0.0[${PYTHON_USEDEP}]
		dev-python/omemo-dr[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/precis-i18n[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
		dev-python/secretstorage[${PYTHON_USEDEP}]
		media-libs/gsound[introspection]
		net-libs/libsoup:3.0[introspection]
		geolocation? ( app-misc/geoclue[introspection] )
		jingle? (
			net-libs/farstream:0.2[introspection]
			media-libs/gstreamer:1.0[introspection]
			media-libs/gst-plugins-base:1.0[introspection]
			media-libs/gst-plugins-ugly:1.0
			media-plugins/gst-plugins-gtk
		)
		remote? (
			>=dev-python/dbus-python-1.2.0[${PYTHON_USEDEP}]
			sys-apps/dbus[X]
		)
		rst? ( dev-python/docutils[${PYTHON_USEDEP}] )
		spell? (
			app-text/gspell[introspection]
			app-text/hunspell
		)
		upnp? ( net-libs/gupnp-igd:0[introspection] )
	')"

python_compile() {
	distutils-r1_python_compile
	./pep517build/build_metadata.py -o dist/metadata
}

python_install() {
	distutils-r1_python_install
	./pep517build/install_metadata.py dist/metadata --prefix="${D}/usr"

	rm "${D}"/usr/share/man/man1/*.gz || die
	doman data/*.1
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

# Tests are unfortunately regularly broken
RESTRICT="test"
