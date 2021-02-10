DESCRIPTION = "ARCHCONFIG"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit update-rc.d

RDEPENDS_${PN} = "bash fru-print dnf"

INITSCRIPT_NAME = "archconfig.sh"
INITSCRIPT_PARAMS = "start 99 S ."
SRC_URI = "file://archconfig.sh"

do_install() {
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/archconfig.sh ${D}${sysconfdir}/init.d/
}

FILES_${PN} = "${sysconfdir}/init.d/archconfig.sh"
