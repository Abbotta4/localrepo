# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3
EGIT_REPO_URI="https://github.com/salman-abedin/devour.git"
KEYWORDS="~amd64"

DESCRIPTION="Window Manager agnostic swallowing feature for terminal emulators"
HOMEPAGE="https://github.com/salman-abedin/devour"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="x11-misc/xdo"

src_prepare() {
	# FHS/Gentoo Policy states apps go in /usr/bin
	sed -i -e 's@/usr/local@/usr@g' Makefile || die
	default
}

src_compile() {
	:;
}