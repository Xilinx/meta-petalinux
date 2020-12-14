FILES_${PN}_ultra96 = "/usr/share/ultra96-startup-pages/webapp/static/src-noconflict"

do_install_ultra96 () {
    install -d ${D}/${datadir}/ultra96-startup-pages/webapp/static/src-noconflict
    rsync -r --exclude=".*" ${S}/src-noconflict/* ${D}/${datadir}/ultra96-startup-pages/webapp/static/src-noconflict
}

PACKAGE_ARCH_ultra96 = "${BOARD_ARCH}"
