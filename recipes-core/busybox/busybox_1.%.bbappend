FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

PACKAGES =+ "${PN}-inetd"
FILES_${PN}-inetd = "${sysconfdir}/init.d/inetd.busybox ${sysconfdir}/inetd.conf"

INITSCRIPT_NAME_${PN}-inetd = "inetd.busybox"
INITSCRIPT_PACKAGES += "${PN}-inetd"

RRECOMMENDS_${PN} += "${PN}-inetd"

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

