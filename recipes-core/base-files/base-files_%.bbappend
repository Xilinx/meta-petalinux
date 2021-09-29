FILESEXTRAPATHS:prepend  := "${THISDIR}/files:"

SRC_URI += "file://xilinx.sh"

dirs755:append = " ${sysconfdir}/profile.d"

do_install:append () {
        install -m 0755 ${WORKDIR}/xilinx.sh ${D}${sysconfdir}/profile.d/xilinx.sh
}

RRECOMMENDS:${PN}:append = " base-files-plnx"
