EAPI=7

PYTHON_COMPAT=( python3_9 )
DISTUTILS_SINGLE_IMP=1
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1 xdg-utils

DESCRIPTION="An MMO originally by Disney, rewritten. An account is needed to play."
HOMEPAGE="http://www.toontownrewritten.com"
_SRC_URI="https://www.xytime.xyz/flatpaks/repo"
LICENSE="Toontown-Online-EULA"
KEYWORDS="amd64"
PROPERTIES+="live"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

SLOT="0"
#RESTRICT="mirror"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/gssapi
		dev-python/PyQt5
		dev-python/PyQtWebEngine
		dev-python/requests
		dev-python/bsdiff4
	')
"
DEPEND="
	dev-util/ostree
"

PATCHES=(
	"${FILESDIR}/${PN}-frame.py.patch"
	"${FILESDIR}/${PN}-launcher.py.patch"
	"${FILESDIR}/${PN}-toontown.patch"
)

pkg_nofetch() {
	elog ""
	elog "To download sources, execute the following in ${DISTDIR}:"
	elog ""
	elog "  ostree --repo=repo init --mode=bare-user-only"
	elog "  ostree --repo=repo remote add origin "https://www.xytime.xyz/flatpaks/repo" --no-gpg-verify"
	elog "  ostree --repo=repo pull --mirror origin"
	elog "  ostree --repo=repo checkout -U -M -v \$(cat repo/refs/heads/app/xyz.xytime.Toontown/x86_64/master)"
	elog ""
}

src_unpack() {
	ostree --repo=repo init --mode=bare-user-only
	ostree --repo=repo remote add origin ${_SRC_URI} --no-gpg-verify
	ostree --repo=repo pull --mirror origin
	local MASTER_HASH=$(cat repo/refs/heads/app/xyz.xytime.Toontown/x86_64/master)
	ostree --repo=repo checkout -U -M -v ${MASTER_HASH}
	mkdir -p ${S}/src
	cp ${MASTER_HASH}/files/bin/toontown ${S}/
	cp -r ${MASTER_HASH}/files/share/{applications,icons,ttassets} ${S}
	cp -r ${MASTER_HASH}/files/lib/python3.7/site-packages/{fsm,gui,launcher,patcher} ${S}/src
	cp ${FILESDIR}/{pyproject.toml,setup.cfg} ${S}
}

src_install() {
	distutils-r1_src_install

	insinto /usr/share
	doins -r ttassets
	insinto /usr/bin
	doins toontown
	fperms 755 /usr/bin/toontown
	insinto /usr/share/applications
	doins applications/xyz.xytime.Toontown.desktop
	insinto /usr/share/icons/hicolor/256x256/apps
	doins icons/hicolor/256x256/apps/xyz.xytime.Toontown.png
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}