SUMMARY = "OSPI Versal daemon"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit update-rc.d

SRC_URI = "file://ospi-versal.sh \
           file://ov-start.sh"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_vck5000 = "${MACHINE}"

INITSCRIPT_NAME = "ov-start.sh"
INITSCRIPT_PARAMS = "start 99 S ."

do_install() {
	install -d ${D}${bindir}/
	install -m 0755 ${WORKDIR}/ospi-versal.sh ${D}${bindir}/ospi-versal.sh

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/ov-start.sh ${D}${sysconfdir}/init.d/ov-start.sh
}

