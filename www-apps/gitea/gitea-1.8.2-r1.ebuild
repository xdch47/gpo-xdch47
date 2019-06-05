# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.io"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
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
	GOPATH=${WORKDIR}/${P}:$(get_golibdir_gopath) emake "${my_makeopt[@]}" "$@"
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
	newconfd - gitea <<-_EOF_
		# Gitea configuration (setcap cap_net_bind_service+ep /usr/bin/gitea if using ports < 1024)
		GITEA_CONF="${EPREFIX}/etc/gitea/app.ini"

		# Gitea user / group
		GITEA_USER="git"
		GITEA_GROUP="git"

		# Gitea directories
		GITEA_WORK_DIR="${EPREFIX}/var/lib/gitea"
		GITEA_CUSTOM="\${GITEA_WORK_DIR}/custom"
	_EOF_

	newinitd - gitea <<-_EOF_
		#!/sbin/openrc-run
		# Copyright 2016-2019 Gentoo Authors
		# Distributed under the terms of the GNU General Public License v2

		description="Gitea, a self-hosted Git service"

		: \${GITEA_CONF:=/etc/gitea/app.ini}
		: \${GITEA_USER:=git}
		: \${GITEA_GROUP:=git}
		: \${GITEA_WORK_DIR:=/var/lib/gitea}
		: \${GITEA_CUSTOM:=\${GITEA_WORK_DIR}/custom}

		command="/usr/bin/gitea web"
		command_args="--config \${GITEA_CONF}"
		command_background="true"
		command_user="\${GITEA_USER}:\${GITEA_GROUP}"
		error_log="/var/log/\${RC_SVCNAME}/\${RC_SVCNAME}.err"
		pidfile="/run/\${RC_SVCNAME}.pid"
		required_files="\${GITEA_CONF}"
		start_stop_daemon_args="--chdir \${GITEA_WORK_DIR}"
		start_stop_daemon_args="\${start_stop_daemon_args} -e GITEA_WORK_DIR=\${GITEA_WORK_DIR}"
		start_stop_daemon_args="\${start_stop_daemon_args} -e GITEA_CUSTOM=\${GITEA_CUSTOM}"
	_EOF_

	systemd_newunit - gitea.service <<-_EOF_
		[Unit]
		Description=Gitea service
		Documentation=https://docs.gitea.io/

		AssertPathIsDirectory=/var/lib/gitea
		AssertPathIsReadWrite=/var/lib/gitea

		After=network.target
		Requires=network.target
		After=mysqld.service
		After=postgresql-9.3.service
		After=postgresql-9.4.service
		After=postgresql-9.5.service
		After=postgresql-9.6.service
		After=postgresql-10.service
		After=postgresql-11.service
		After=postgresql-12.service
		After=memcached.service
		After=redis.service

		[Service]
		User=git
		Group=git

		Environment="GITEA_WORK_DIR=/var/lib/gitea" "GITEA_CUSTOM=/var/lib/gitea/custom"
		WorkingDirectory=/var/lib/gitea
		ExecStart=/usr/bin/gitea web --config /etc/gitea/app.ini

		Restart=always
		PrivateTmp=true
		Nice=5

		[Install]
		WantedBy=multi-user.target
	_EOF_

	diropts -m0750 -o git -g git
	keepdir /etc/gitea
	keepdir /var/lib/gitea /var/lib/gitea/custom /var/lib/gitea/data
	keepdir /var/log/gitea
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/etc/gitea/app.ini" ]]; then
		elog "Please make sure that your 'git' user has the correct homedir (/var/lib/gitea)."
		elog "No app.ini found, copying initial config over"
		cat > "$EROOT"/etc/gitea/app.ini <<-_EOF_
			[log]
			MODE      = file
			LEVEL     = Info
			ROOT_PATH = /var/log/gitea
		_EOF_
		chown git:git "${EROOT}"/etc/gitea/app.ini || die

		if [[ -e "${EROOT}/var/lib/gitea/conf/app.ini" ]] ; then
			ewarn "The configuration path has been changed to ${EROOT}/etc/gitea/app.ini."
			ewarn "Please adapt the gitea-repositories hooks and ssh authorized_keys."
			ewarn "Depending on your configuration you should run something like:"
			ewarn "sed -i -e 's#/var/lib/gitea/conf/app.ini#/etc/gitea/app.ini#' \\"
			ewarn "  /var/lib/gitea/gitea-repositories/*/*/hooks/*/* \\"
			ewarn "  /var/lib/gitea/.ssh/authorized_keys"
		fi
	else
		elog "app.ini found, please check the sample file for possible changes"
	fi
}
