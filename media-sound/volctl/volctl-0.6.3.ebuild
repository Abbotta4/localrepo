# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 distutils-r1
	EGIT_REPO_URI="https://github.com/buzz/${PN}.git"
	KEYWORDS=""
else
	inherit distutils-r1
	SRC_URI="https://github.com/buzz/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="PulseAudio-enabled tray icon volume control for GNU/Linux desktops"
HOMEPAGE="https://buzz.github.io/volctl/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+pavucontrol"

DEPEND=""
RDEPEND="dev-util/desktop-file-utils
	media-sound/pulseaudio
	dev-python/pygobject
	pavucontrol? ( media-sound/pavucontrol )"

pkg_postinst()
{
	glib-compile-schemas /usr/share/glib-2.0/schemas/
}