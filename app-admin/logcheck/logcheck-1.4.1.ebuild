# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 tmpfiles

DESCRIPTION="Mails anomalies in the system logfiles to the administrator"
HOMEPAGE="https://packages.debian.org/sid/logcheck"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="
	acct-group/logcheck
	acct-user/logcheck
"
RDEPEND="${DEPEND}
	!app-admin/logsentry
	app-misc/lockfile-progs
	dev-lang/perl
	dev-perl/mime-construct
	virtual/mailx
"

DOC_CONTENTS="
	Please read the guide at https://wiki.gentoo.org/wiki/Logcheck
	for installation instructions.
"

src_prepare() {
	# Do not install /var/lock, bug #449968 .
	sed -i -e '\#install -d $(DESTDIR)/var/lock/logcheck$#d' Makefile || die
	default
}

src_install() {
	default

	keepdir /var/lib/logcheck
	fowners logcheck:logcheck /var/lib/logcheck
	fowners -R logcheck:logcheck /etc/logcheck

	readme.gentoo_create_doc
	dodoc AUTHORS CHANGES CREDITS TODO docs/README.*
	doman docs/logtail.8 docs/logtail2.8

	newtmpfiles - logcheck.conf <<-EOF
		d /run/lock/logcheck 0755 logcheck logcheck
	EOF

	exeinto /etc/cron.hourly
	doexe "${FILESDIR}/${PN}.cron"
}

pkg_postinst() {
	tmpfiles_process logcheck.conf
	readme.gentoo_print_elog
}
