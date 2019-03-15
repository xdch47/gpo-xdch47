# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"
KEYWORDS="~amd64 ~arm"

DESCRIPTION="A painless self-hosted Git service, written in Go"
HOMEPAGE="https://gitea.io/"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="pam sqlite"

S="${WORKDIR}/${P}/src/${EGO_PN}"

COMMON_DEPEND="pam? ( sys-libs/pam )"

DEPEND="
	${COMMON_DEPEND}
	dev-go/go-bindata
"
RDEPEND="
	${COMMON_DEPEND}
	dev-vcs/git
"

GITEA_USER=git
GITEA_GROUP=git

pkg_setup() {
	enewgroup ${GITEA_GROUP}
	enewuser ${GITEA_USER} -1 /bin/bash /var/lib/gitea ${GITEA_GROUP}
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
	GOPATH=${WORKDIR}/${P}:$(get_golibdir_gopath) emake "${my_makeopt[@]}" $1 || die "make $1 failed"
}

src_prepare() {
	default
	sed -i                                     \
		-e "s/-ldflags '-s/-ldflags '/"        \
		-e "s/GOFLAGS := -i -v/GOFLAGS := -v/" \
		Makefile || die
	sed -i                                                                          \
		-e "s#^RUN_MODE = dev#RUN_MODE = prod#"                                     \
		-e "s#^ROOT =#ROOT = ${EPREFIX}/var/lib/gitea/gitea-repositories#"          \
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#"                   \
		-e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${EPREFIX}/var/lib/gitea/data#" \
		-e "s#^HTTP_ADDR = 0.0.0.0#HTTP_ADDR = 127.0.0.1#"                          \
		-e "s#^MODE = console#MODE = file#"                                         \
		-e "s#^LEVEL = Trace#LEVEL = Info#"                                         \
		-e "s#^LOG_SQL = true#LOG_SQL = false#"                                     \
		-e "s#^DISABLE_ROUTER_LOG = false#DISABLE_ROUTER_LOG = true#"               \
		-e "s#^APP_ID =#;APP_ID =#"                                                 \
		-e "s#^TRUSTED_FACETS =#;TRUSTED_FACETS =#"                                 \
		custom/conf/app.ini.sample || die
	if use sqlite ; then
		sed -i -e "s#^DB_TYPE = .*#DB_TYPE = sqlite3#" custom/conf/app.ini.sample || die
	fi

	gitea_make generate
}

src_compile() {
	gitea_make build
}

src_test() {
	gitea_make test
}

src_install() {
	dobin gitea

	diropts -m0750 -o ${GITEA_USER} -g ${GITEA_GROUP}
	keepdir /var/log/gitea /var/lib/gitea /var/lib/gitea/data
	newinitd "${FILESDIR}/gitea.initd" gitea
	newconfd "${FILESDIR}/gitea.confd-r1" gitea
	systemd_dounit "${FILESDIR}/gitea.service"

	diropts -m0750 -o root -g ${GITEA_GROUP}
	dodir /etc/gitea
	insopts -m660  -o root -g ${GITEA_GROUP}
	insinto /etc/gitea
	newins custom/conf/app.ini.sample app.ini
}

pkg_postinst() {
	if [[ -e "${EROOT}var/lib/gitea/conf/app.ini" ]] ; then
		ewarn "The default path for the gitea configuration has been changed to ${EROOT}var/lib/gitea/conf/app.ini."
		ewarn "In order to migrate the path in the gitea-repositories hooks and ssh authorized_keys have to be adapted."
		ewarn "Depending on your configuration you should run something like:"
		ewarn "  sed -i.backup -e 's#/var/lib/gitea/conf/app.ini#/etc/gitea/app.ini#' /var/lib/gitea/gitea-repositories/**/**/hooks/**/*"
		ewarn "  sed -i.backup -e 's#/var/lib/gitea/conf/app.ini#/etc/gitea/app.ini#' /var/lib/gitea/.ssh/authorized_keys"
	fi
}
