DESCRIPTION = "xmutil"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS_${PN} = "python3-core fru-print dfx-mgr"
inherit python3-dir

S = "${WORKDIR}/git"

SRC_URI += " \
    git://gitenterprise.xilinx.com/SOM/xmutil.git;branch=master;protocol=https \
    "
SRCREV="931e1ad2f4c15c4040784dbaa6bb2d25f7908b43"

do_install() {
    install -d ${D}${bindir}/
    install -m 0755 ${S}/xmutil ${D}${bindir}/
}

FILES_${PN} += "${bindir}/xmutil"
