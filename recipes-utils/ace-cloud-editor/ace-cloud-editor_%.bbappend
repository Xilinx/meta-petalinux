FILES_${PN}_ultra96-zynqmp = "/usr/share/ultra96-startup-pages/webapp/static/src-noconflict"

do_install_ultra96-zynqmp () {
    install -d ${D}/${datadir}/ultra96-startup-pages/webapp/static/src-noconflict
    rsync -r --exclude=".*" ${S}/src-noconflict/* ${D}/${datadir}/ultra96-startup-pages/webapp/static/src-noconflict
}

