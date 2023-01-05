FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "${THISDIR}/busybox:"

python () {
    if d.getVar('WITHIN_PLNX_FLOW') and d.getVar('SYSCONFIG_DIR'):
        d.prependVar('FILESEXTRAPATHS', '%s/busybox:' % d.getVar('SYSCONFIG_DIR'))
}

PACKAGES =+ "${PN}-inetd"
FILES:${PN}-inetd = "${sysconfdir}/init.d/inetd.busybox ${sysconfdir}/inetd.conf"

INITSCRIPT_NAME:${PN}-inetd = "inetd.busybox"
INITSCRIPT_PACKAGES += "${PN}-inetd"

RRECOMMENDS:${PN} += "${PN}-inetd"

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

