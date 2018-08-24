FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://weston.ini"

do_install_append() {
    install -Dm 0700 ${WORKDIR}/weston.ini ${D}/${sysconfdir}/xdg/weston/weston.ini
}
