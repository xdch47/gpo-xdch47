# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provides for an easy dynamic modification of a user's environment"
HOMEPAGE="https://envmodules.io"

SRC_URI="https://github.com/envmodules/modules/releases/download/v${PV}/modules-${PV}.tar.gz"
S=${WORKDIR}/modules-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-lang/tcl-7.0.0:0
	nagelfar? ( dev-tcltk/nagelfar )
"

RDEPEND="$DEPEND"

IUSE="doc example-modulefiles vim-syntax nagelfar"

src_configure() {
	# handcrafted configure -- prefix is MODULESHOME
	conf=(
		--prefix="${EPREFIX}/usr/share/modules"
		--bindir="${EPREFIX}/usr/bin"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--libexecdir="${EPREFIX}/usr/lib/environment-modules"
		--etcdir="${EPREFIX}/etc/environment-modules"
		--initdir="${EPREFIX}/usr/share/modules/init"
		--datarootdir="${EPREFIX}/usr/share"
		--mandir="${EPREFIX}/usr/share/man"
		--docdir="${EPREFIX}/usr/share/doc/environment-modules"
		--vimdatadir="${EPREFIX}/usr/share/vim/vimfiles"
		--modulefilesdir="${EPREFIX}/usr/share/modules/modulefiles"
		--with-modulepath="${EPREFIX}/etc/environment-modules/modulefiles"
		--enable-modulespath
		--disable-set-binpath
		--disable-set-manpath
		$(use_enable example-modulefiles)
		$(use_enable doc doc-install) \
		--enable-new-features
		--enable-quarantine-support
		--enable-require-via
		--enable-set-shell-startup
		--enable-silent-shell-debug-support
		--enable-unique-name-loaded
		$(use_enable vim-syntax vim-addons)
	)

	use nagelfar && conf+=(--with-tcl-linter=/usr/bin/nagelfar)

	./configure "${conf[@]}"
}

src_compile() {
	emake -C doc all
}

pkg_postinst() {
	elog ""
	elog "ZSH: For the use of module-cmd in a none-login Z-shell enviroment"
	elog "the following entry should be added to the zshrc"
	elog "(or zshenv if the module-cmd should be available in shell-scripts)"
	elog ""
	elog "  (( \${+functions[module]} )) || source ${EPREFIX}/etc/modules/init/zsh"
	elog ""
	elog "Adapt /etc/modules/init/modulerc and add your modulefiles to the specified directories."
	elog ""
}
