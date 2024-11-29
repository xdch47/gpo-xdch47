EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit git-r3 python-single-r1

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
EGIT_REPO_URI=https://github.com/YosysHQ/yosys
EGIT_COMMIT=$PV
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
PATCHES=( $FILESDIR/$PN-makefile.patch )

IUSE="+abc clang +libffi +libedit readline python"

DEPEND="!readline? ( libedit? ( dev-libs/libedit:= ) )
	readline? (
		sys-libs/readline:=
		sys-libs/ncurses:=
	)
	dev-lang/tcl:=
	python? ( $(python_gen_cond_dep 'dev-libs/boost[${PYTHON_USEDEP}]') )
	libffi? ( dev-libs/libffi )
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	python? ( ${PYTHON_DEPS} )
	media-gfx/xdot
"


src_configure() {
	if use clang ; then
		emake config-clang
	else
		emake config-gcc
	fi
	cat <<-__EOF__ >> Makefile.conf
		PREFIX := ${EPREFIX}/usr
		STRIP := :
		ENABLE_ABC := $(usex abc 1 0)
		ENABLE_PLUGINS := $(usex libffi 1 0)
		ENABLE_READLINE := $(usex readline 1 0)
		ENABLE_EDITLINE := $(usex libedit 1 0)
		ENABLE_PYOSYS := $(usex python 1 0)
	__EOF__
}

src_install() {
	default
	python_optimize
}

