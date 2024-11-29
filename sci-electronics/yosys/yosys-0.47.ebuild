EAPI=8

inherit git-r3

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
EGIT_REPO_URI=https://github.com/YosysHQ/yosys
EGIT_COMMIT=$PV
LICENSE=ISC
SLOT=0
KEYWORDS=amd64
PATCHES=( $FILESDIR/$PN-makefile.patch )

DEPEND="dev-vcs/git
	media-gfx/xdot
	dev-libs/boost
	sys-devel/clang"

src_compile() 
{
  emake DESTDIR="$D" PREFIX=/usr
}

src_install() 
{
  emake DESTDIR="$D" PREFIX=/usr install	
}
