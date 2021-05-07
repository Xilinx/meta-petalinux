FILESEXTRAPATHS_prepend  := "${THISDIR}/files:"

SRC_URI += "file://xilinx.sh"

dirs755_append = " ${sysconfdir}/profile.d"

do_install_append () {
        install -m 0755 ${WORKDIR}/xilinx.sh ${D}${sysconfdir}/profile.d/xilinx.sh
}

RRECOMMENDS_${PN}_append = " base-files-plnx"
