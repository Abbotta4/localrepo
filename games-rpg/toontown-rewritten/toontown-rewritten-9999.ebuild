EAPI=7

PYTHON_COMPAT=( python3_10 )
inherit xdg-utils python-single-r1

DESCRIPTION="An MMO originally by Disney, rewritten."
HOMEPAGE="http://www.toontownrewritten.com"
_SRC_URI="https://cdn.toontownrewritten.com/flatpak"
LICENSE="Toontown-Online-EULA"
KEYWORDS="amd64"
PROPERTIES+="live"
RESTRICT="network-sandbox"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

SLOT="0"
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyside2[webengine,${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/bsdiff4[${PYTHON_USEDEP}]
	')
"
DEPEND="
	dev-util/ostree
"

PATCHES=(
	"${FILESDIR}/${PN}-rm-envs.patch"
)

pkg_nofetch() {
	elog ""
	elog "To download sources, execute the following in ${DISTDIR}:"
	elog ""
	elog "  ostree --repo=repo init --mode=bare-user-only"
	elog "  ostree --repo=repo config set core.min-free-space-percent 0"
	elog "  ostree --repo=repo remote add origin \"https://cdn.toontownrewritten.com/flatpak\" --no-gpg-verify"
	elog "  ostree --repo=repo pull --mirror origin"
	elog "  ostree --repo=repo checkout -U -M -v \$(cat repo/refs/heads/app/com.toontownrewritten.Launcher/x86_64/master)"
	elog ""
}

src_unpack() {
	ostree --repo=repo init --mode=bare-user-only
	ostree --repo=repo config set core.min-free-space-percent 0
	ostree --repo=repo remote add origin ${_SRC_URI} --no-gpg-verify
	ostree --repo=repo pull --mirror origin || die
	local MASTER_HASH=$(cat repo/refs/heads/app/com.toontownrewritten.Launcher/x86_64/master)
	ostree --repo=repo checkout -U -M -v ${MASTER_HASH}
	mkdir -p ${S}
	cp ${MASTER_HASH}/files/bin/toontown ${S}/
	cp -r ${MASTER_HASH}/files/share/icons ${S}/
	cp -r ${MASTER_HASH}/files/resources ${S}/
	cp -r ${MASTER_HASH}/files/lib/python3.10/site-packages/{fsm,gui,launcher,patcher,start.py} ${S}/
	cp ${FILESDIR}/com.toontownrewritten.Launcher.desktop ${S}/
}

src_install() {
	python_scriptinto /usr/bin
	python_doscript toontown
	insinto /usr/share/applications
	doins com.toontownrewritten.Launcher.desktop
	python_moduleinto .
	python_domodule fsm gui launcher patcher
	insinto /usr/lib/python3.10/site-packages/
	doins start.py
	insinto /usr/share/toontown
	doins -r resources
	python_optimize
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
