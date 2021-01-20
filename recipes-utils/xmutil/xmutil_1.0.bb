DESCRIPTION = "xmutil"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS_${PN} = "python3-core fru-print"
inherit python3-dir

SRC_URI += " \
    file://xmutil.py \
    "

do_install() {
    install -d ${D}${bindir}/
    install -m 0755 ${WORKDIR}/xmutil.py ${D}${bindir}/
}

FILES_${PN} += "${bindir}/xmutil.py"
