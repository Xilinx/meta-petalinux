
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

SRC_URI += " \
                file://inetd.conf \
                file://petalinux.cfg \
                file://ftp.cfg \
                file://ftpd.cfg \
                file://hexdump.cfg \
                file://httpd.cfg \
                file://inetd.cfg \
                file://nc.cfg \
                file://telnetd.cfg \
                file://tftpd.cfg \
                "

PACKAGES =+ "${@plnx_enable_busybox_package('inetd', d)}"

INITSCRIPT_PACKAGES =+ "${@plnx_enable_busybox_package('inetd', d)}"

FILES_${PN}-inetd = "${sysconfdir}/init.d/busybox-inetd ${sysconfdir}/inetd.conf"
INITSCRIPT_NAME_${PN}-inetd = "inetd.busybox"
INITSCRIPT_PARAMS_${PN}-inetd = "start 65 S ."
CONFFILES_${PN}-inetd = "${sysconfdir}/inetd.conf"

RRECOMMENDS_${PN} =+ "${@bb.utils.contains('DISTRO_FEATURES', 'busybox-inetd', '${PN}-inetd', '', d)}"

def plnx_enable_busybox_package(f, d):
    distro_features = (d.getVar('DISTRO_FEATURES', True) or "").split()
    if "busybox-" + f in distro_features:
        return "${PN}-" + f
    else:
        return ""

