# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

hg_rev="88d414c916ee"
modname="mod_http_upload"
modfiles=(
	"${modname}.lua"
	"README.markdown"
)

DESCRIPTION="HTTP Upload file transfer mechanism used by Conversations"
HOMEPAGE="https://hg.prosody.im/prosody-modules"
for modfile in ${modfiles[@]}; do
	SRC_URI+=" https://hg.prosody.im/prosody-modules/raw-file/${hg_rev}/${modname}/${modfile} -> ${modname}-${modfile}"
done

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	net-im/prosody"
BDEPEND=""

src_unpack() {
	mkdir "${S}"
	for modfile in ${modfiles[@]}; do
		cp "${DISTDIR}/${modname}-${modfile}" "${S}/${modfile}"
	done
}

src_install() {
	dodoc "README.markdown"
	insinto /usr/$(get_libdir)/prosody/modules
	doins ${modname}.lua
}
