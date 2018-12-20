# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Move windows from one monitor (xfce4)"
HOMEPAGE="https://github.com/jc00ke/move-to-next-monitor"
EGIT_REPO_URI="https://github.com/jc00ke/move-to-next-monitor"
EGIT_COMMIT="c4d66935ba665b2728dea61cfe3164b175500684"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	x11-apps/xdpyinfo
	x11-apps/xprop
	x11-apps/xwininfo
	x11-misc/wmctrl
	x11-misc/xdotool"

src_install() {
	dobin move-to-next-monitor
}
