
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

