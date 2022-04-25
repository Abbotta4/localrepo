EAPI=7

inherit desktop udev unpacker xdg

DESCRIPTION="Linux version of TomTom Sports Connect"
HOMEPAGE="https://help.tomtom.com/hc/en-us/articles/360013958479-Linux-version-of-TomTom-Sports-Connect"
SRC_URI="https://sports.tomtom-static.com/downloads/desktop/mysportsconnect/latest/tomtomsportsconnect-${PV}.x86_64.deb"
LICENSE="Proprietary"
KEYWORDS="amd64"
RESTRICT="mirror bindist"

S=${WORKDIR}
SLOT="0"
RDEPEND="
	=media-libs/gstreamer-0.10.36-r2
	=media-libs/gst-plugins-base-0.10.36-r2
	dev-qt/qtxmlpatterns
	dev-qt/qt3d
	dev-db/mysql
"
BUILD="
	dev-util/patchelf
"
src_prepare() {
	default

	sed -i \
		-e "s:/usr/local/TomTomSportsConnect:/opt/${PN}/:g" \
		usr/share/applications/${PN//-/}.desktop || die
}

src_install() {
	doicon -s 16 usr/share/icons/hicolor/16x16/apps/tomtomsportsconnect.png
	doicon -s 32 usr/share/icons/hicolor/32x32/apps/tomtomsportsconnect.png
	doicon -s 48 usr/share/icons/hicolor/48x48/apps/tomtomsportsconnect.png
	domenu usr/share/applications/tomtomsportsconnect.desktop

	udev_dorules ${FILESDIR}/90-tomtom-sports-connect.rules

	insinto /opt/${PN}
	doins -r usr/local/TomTomSportsConnect/.
	fperms +x /opt/${PN}/bin/TomTomSportsConnect /opt/${PN}/libexec/QtWebProcess
	dosym ../../opt/${PN}/bin/TomTomSportsConnect usr/bin/${PN}
}

pkg_postinst() {
	xdg_pkg_postinst
	udev_reload
}

pkg_postrm() {
	xdg_pkg_postinst
	udev_reload
}