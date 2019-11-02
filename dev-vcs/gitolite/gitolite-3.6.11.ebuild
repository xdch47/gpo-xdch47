# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Highly flexible server for git directory version tracker"
HOMEPAGE="https://github.com/sitaramc/gitolite"
SRC_URI="https://github.com/sitaramc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 arm x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="+acct selinux tools"

DEPEND="
	acct? (
		acct-group/git
		acct-user/git[gitolite]
	)
	dev-lang/perl
	virtual/perl-File-Path
	virtual/perl-File-Temp
	>=dev-vcs/git-1.6.6"
RDEPEND="${DEPEND}
	!app-vim/gitolite-syntax
	!dev-vcs/gitolite-gentoo
	selinux? ( sec-policy/selinux-gitosis )
	dev-perl/JSON"

src_prepare() {
	default
	echo $PF > src/VERSION || die
}

src_install() {
	local uexec=/usr/libexec/${PN}

	rm -rf src/lib/Gitolite/Test{,.pm}
	insinto $VENDOR_LIB
	doins -r src/lib/Gitolite

	dodoc README.markdown CHANGELOG
	# These are meant by upstream as examples, you are strongly recommended to
	# customize them for your needs.
	dodoc contrib/utils/ipa_groups.pl contrib/utils/ldap_groups.sh

	insinto /usr/share/vim/vimfiles
	doins -r contrib/vim/*

	insopts -m0755
	insinto $uexec
	doins -r src/{commands,syntactic-sugar,triggers,VREF}/
	doins -r contrib/{commands,triggers,hooks}

	insopts -m0644
	doins src/VERSION

	exeinto $uexec
	doexe src/gitolite{,-shell}

	dodir /usr/bin
	for bin in gitolite{,-shell}; do
		dosym ../libexec/${PN}/${bin} /usr/bin/${bin}
	done

	if use tools; then
		dobin check-g2-compat convert-gitosis-conf
		dobin contrib/utils/rc-format-v3.4
	fi

	fperms 0644 ${uexec}/VREF/MERGE-CHECK # It's meant as example only
}
