# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provides for an easy dynamic modification of a user's environment."
HOMEPAGE="https://envmodules.io"

SRC_URI="https://github.com/envmodules/modules/releases/download/v${PV}/modules-${PV}.tar.gz"
S=${WORKDIR}/modules-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/tcl-7.0.0:0"
RDEPEND="$DEPEND"

IUSE="doc compat-version example-modulefiles init-profile vim-syntax"

src_configure() {
	# handcrafted configure -- prefix is MODULESHOME
	./configure \
		--prefix="${EPREFIX}" \
		--bindir="${EPREFIX}/usr/bin" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--libexecdir="${EPREFIX}/usr/libexec" \
		--etcdir="${EPREFIX}/etc" \
		--initdir="${EPREFIX}/etc/modules/init" \
		--with-initconf-in=initdir \
		--with-moduleshome="${EPREFIX}/etc/modules" \
		--datarootdir="${EPREFIX}/usr/share" \
		--mandir="${EPREFIX}/usr/share/man" \
		--docdir="${EPREFIX}/usr/share/doc" \
		--vimdatadir="${EPREFIX}/usr/share/vim/vimfiles" \
		--modulefilesdir="${EPREFIX}/etc/modules/modulefiles" \
		$(use_enable compat-version) \
		$(use_enable example-modulefiles) \
		$(use_enable doc doc-install) \
		$(use_enable vim-syntax vim-addons) \
		--disable-set-binpath \
		--disable-set-manpath
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install

	dodir /etc/profile.d
	if use init-profile ; then
		dosym ../modules/init/profile.csh /etc/profile.d/env-modules.csh
		dosym ../modules/init/profile.sh  /etc/profile.d/env-modules.sh
	fi

	dosym ./perl.pm   /etc/modules/init/perl
	dosym ./python.py /etc/modules/init/python
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
