# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"
KEYWORDS="~amd64 ~arm ~arm64"

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.io"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="pam sqlite"

COMMON_DEPEND="pam? ( sys-libs/pam )"
DEPEND="${COMMON_DEPEND}
	dev-go/go-bindata"
RDEPEND="${COMMON_DEPEND}
	dev-vcs/git"

DOCS=( custom/conf/app.ini.sample CONTRIBUTING.md README.md )
S="${WORKDIR}/${P}/src/${EGO_PN}"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
}

gitea_make() {
	local my_tags=(
		bindata
		$(usev pam)
		$(usex sqlite 'sqlite sqlite_unlock_notify' '')
	)
	local my_makeopt=(
		DRONE_TAG=${PV}
		TAGS="${my_tags[@]}"
	)
	GOPATH=${WORKDIR}/${P}:$(get_golibdir_gopath) emake "${my_makeopt[@]}" "$1"
}

src_compile() {
	gitea_make generate
	gitea_make build
}

src_test() {
	gitea_make test
}

src_install() {
	einstalldocs
	dobin gitea
	newconfd "${FILESDIR}"/gitea.confd-r1 gitea
	newinitd "${FILESDIR}"/gitea.initd-r2 gitea
	systemd_newunit "${FILESDIR}"/gitea.service-r2 gitea.service
	diropts -m0750 -o git -g git
	keepdir /etc/gitea
	keepdir /var/lib/gitea /var/lib/gitea/custom /var/lib/gitea/data
	keepdir /var/log/gitea
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/etc/gitea/app.ini" ]]; then
		cp "${FILESDIR}"/app.ini "${EROOT}"/etc/gitea/ || die
		chown git:git "${EROOT}"/etc/gitea/app.ini || die
	fi
}
