FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " file://haveged-setup.sh"

INITSCRIPT_NAME = "haveged-setup.sh"
INITSCRIPT_PARAMS = "start 85 S ."

do_install_append() {
        install -d ${D}${sysconfdir}/init.d/
        install -m 0755 ${WORKDIR}/haveged-setup.sh ${D}${sysconfdir}/init.d/haveged-setup.sh
}

MIPS_INSTRUCTION_SET = "mips"
