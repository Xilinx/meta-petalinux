DESCRIPTION = "Init script to read the legacy FRU data from EEPROM \
		and load dtbo and bin files for zynqmp devices"
SUMMARY = "Init script to read the legacy FRU data from EEPROM \
		and load dtbo and bin files for zynqmp devies"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://board-fpga-autoload.sh \
	   file://board-fpga-autoload.service \
"

inherit update-rc.d systemd

RDEPENDS:${PN} += "fpga-manager-script"

INITSCRIPT_NAME = "board-fpga-autoload.sh"
INITSCRIPT_PARAMS = "start 99 S ."

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE:${PN}="board-fpga-autoload.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp = ".*"

do_install () {

	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
    		install -d ${D}${sysconfdir}/init.d/
    		install -m 0755 ${WORKDIR}/board-fpga-autoload.sh ${D}${sysconfdir}/init.d/
	fi

    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/board-fpga-autoload.sh ${D}${bindir}/
    install -d ${D}${systemd_system_unitdir} 
    install -m 0644 ${WORKDIR}/board-fpga-autoload.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "${@bb.utils.contains('DISTRO_FEATURES','sysvinit','${sysconfdir}/init.d/board-fpga-autoload.sh', '', d)}"
