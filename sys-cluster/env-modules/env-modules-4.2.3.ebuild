# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provides for an easy dynamic modification of a user's environment."
HOMEPAGE="https://sourceforge.net/projects/modules/"

SRC_URI="https://github.com/cea-hpc/modules/releases/download/v${PV}/modules-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc compat-version example-modulefiles init-profile zshcomp-patch"

DEPEND=">=dev-lang/tcl-7.0.0:0"
RDEPEND="$DEPEND"

S=${WORKDIR}/modules-${PV}

install_prefix=/usr
config_path=/etc
profiled="/etc/profile.d"
moduledir=modules

src_prepare() {
	# module-wise completion
	use zshcomp-patch && eapply "${FILESDIR}/zshcomp-4.1.4.patch"

	default
}

src_configure() {
	./configure \
		--prefix=$install_prefix \
		--docdir=$install_prefix/share/doc/$moduledir \
		--initdir=$config_path/$moduledir/init \
		--modulefilesdir=$config_path/$moduledir/modulefiles \
		$(use_enable compat-version) \
		$(use_enable example-modulefiles) \
		$(use_enable doc doc-install) \
		--disable-set-binpath \
		--disable-set-manpath
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${ED}" install

	dodir ${profiled}
	use init-profile && dosym ${config_path}/$moduledir/init/profile.csh ${profiled}/env-modules.csh
	use init-profile && dosym ${config_path}/$moduledir/init/profile.sh  ${profiled}/env-modules.sh

	# Workaround, since Modules needs <PREFIX>/init for auto-intialization
	dosym ..$config_path/$moduledir/init /usr/init
	dosym ./perl.pm $config_path/$moduledir/init/perl
	dosym ./python.py $config_path/$moduledir/init/python
}

pkg_postinst() {
	elog ""
	elog "ZSH: For the use of module-cmd in a none-login Z-shell enviroment"
	elog "the following entry should be added to the zshrc "
	elog "(or zshenv if the module-cmd should be available in shell-scripts)"
	elog ""
	elog "  (( \${+functions[module]} )) || source \${MODULESHOME:-${config_path}/${moduledir}}/init/zsh"
	elog ""
	elog "Adapt /etc/modules/init/modulerc and add your modulefiles to the specified directories."
	elog ""
}
