# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV=${PV//_/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Music On Console - ncurses interface for playing audio files"
HOMEPAGE="https://moc.daper.net"

if [[ ${PV} != 9999* ]] ; then
	SRC_URI="https://github.com/xdch47/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mltframework/shotcut/"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="aac alsa +cache curl debug ffmpeg flac jack +libsamplerate mad +magic modplug musepack
	oss sid sndfile sndio speex timidity tremor +unicode vorbis wavpack"

S="${WORKDIR}"/${MY_P}

RDEPEND="
	>=dev-libs/libltdl-2
	dev-libs/popt
	sys-libs/ncurses:=[unicode(+)?]
	aac? ( media-libs/faad2 )
	alsa? ( >=media-libs/alsa-lib-1.0.11 )
	cache? ( >=sys-libs/db-4.1:= )
	curl? ( >=net-misc/curl-7.15.1 )
	ffmpeg? ( media-video/ffmpeg )
	flac? ( >=media-libs/flac-1.1.3:= )
	jack? ( virtual/jack )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.0 )
	mad? (
		media-libs/libmad
		sys-libs/zlib
		media-libs/libid3tag:=
	)
	magic? ( sys-apps/file )
	modplug? ( >=media-libs/libmodplug-0.7 )
	musepack? (
		media-sound/musepack-tools
		>=media-libs/taglib-1.5
	)
	sid? ( >=media-libs/libsidplay-2.1.1 )
	sndfile? ( >=media-libs/libsndfile-1.0.0 )
	sndio? ( media-sound/sndio )
	speex? ( >=media-libs/speex-1.0.0 )
	timidity? (
		>=media-libs/libtimidity-0.1.0
		media-sound/timidity++
	)
	vorbis? (
		>=media-libs/libogg-1.0
		tremor? ( media-libs/tremor )
		!tremor? ( >=media-libs/libvorbis-1.0 )
	)
	wavpack? ( >=media-sound/wavpack-4.31 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--without-rcc
		$(use_enable debug)
		$(use_enable cache)
		$(use_with oss)
		$(use_with alsa)
		$(use_with jack)
		$(use_with sndio)
		$(use_with magic)
		$(use_with unicode ncursesw)
		$(use_with libsamplerate samplerate)
		$(use_with aac)
		$(use_with ffmpeg)
		$(use_with flac)
		$(use_with modplug)
		$(use_with mad mp3)
		$(use_with musepack)
		$(use_with sid sidplay2)
		$(use_with sndfile)
		$(use_with speex)
		$(use_with timidity)
		$(use_with vorbis vorbis $(usev tremor))
		$(use_with wavpack)
		$(use_with curl)
	)

	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
