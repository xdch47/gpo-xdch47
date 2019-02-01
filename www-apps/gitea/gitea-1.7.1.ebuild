# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"
KEYWORDS="~amd64 ~arm"

DESCRIPTION="A painless self-hosted Git service, written in Go"
HOMEPAGE="https://gitea.io/"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-go/go-bindata
	sys-libs/pam
"
RDEPEND="
	dev-vcs/git
	sys-libs/pam
"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
}

src_prepare() {
	default
	sed -i -e "s/\"main.Version.*$/\"main.Version=${PV}\"/"\
		-e "s/-ldflags '-s/-ldflags '/" \
		-e "s/GOFLAGS := -i -v/GOFLAGS := -v/" \
		"src/${EGO_PN}/Makefile" || die
	sed -i -e "s#^RUN_MODE = dev#RUN_MODE = prod#"\
		-e "s#^LOG_SQL = true#LOG_SQL = false#"\
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#"\
		-e "s#^MODE = console#MODE = console, file#"\
		-e "s#^LEVEL = Trace#LEVEL = Info#"\
		-e "s#^APP_ID =#;APP_ID =#"\
		-e "s#^TRUSTED_FACETS =#;TRUSTED_FACETS =#"\
		"src/${EGO_PN}/custom/conf/app.ini.sample" || die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C "src/${EGO_PN}" generate
	TAGS="bindata pam sqlite" LDFLAGS="" CGO_LDFLAGS="-fno-PIC" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C "src/${EGO_PN}" build
}

src_install() {
	diropts -m0750 -o git -g git
	keepdir /var/log/gitea /var/lib/gitea /var/lib/gitea/data
	pushd "src/${EGO_PN}" >/dev/null || die
	dobin gitea
	insinto /var/lib/gitea/conf
	doins custom/conf/app.ini.sample
	popd >/dev/null || die
	newinitd "${FILESDIR}"/gitea.initd-r1 gitea
	newconfd "${FILESDIR}"/gitea.confd gitea
	systemd_dounit "${FILESDIR}/gitea.service"
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/var/lib/gitea/conf/app.ini" ]]; then
		elog "No app.ini found, copying initial config over"
		cp "${FILESDIR}"/app.ini "${EROOT}"/var/lib/gitea/conf/ || die
		chown git:git /var/lib/gitea/conf/app.ini
	else
		elog "app.ini found, please check example file for possible changes"
		ewarn "Please note that environment variables have been changed:"
		ewarn "GITEA_WORK_DIR is set to /var/lib/gitea (previous value: unset)"
		ewarn "GITEA_CUSTOM is set to '\$GITEA_WORK_DIR/custom' (previous: /var/lib/gitea)"
	fi
}
