SUMMARY = "OSPI Versal daemon"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit update-rc.d systemd

SRC_URI = "\
	file://ospi-versal.sh \
	file://ov-start.sh \
	file://ov-start.service \
	"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:vck5000-versal = "${MACHINE}"

INITSCRIPT_NAME = "ov-start.sh"
INITSCRIPT_PARAMS = "start 99 S ."

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE:${PN}="ov-start.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"

do_install() {
	install -d ${D}${bindir}/
	install -m 0755 ${WORKDIR}/ospi-versal.sh ${D}${bindir}/ospi-versal.sh

	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
	     install -d ${D}${sysconfdir}/init.d/
	     install -m 0755 ${WORKDIR}/ov-start.sh ${D}${sysconfdir}/init.d/ov-start.sh
	fi

	install -d ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/ov-start.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "\
	${@bb.utils.contains('DISTRO_FEATURES','sysvinit','${sysconfdir}/init.d/ov-start.sh', '', d)} ${systemd_system_unitdir} \
	"
