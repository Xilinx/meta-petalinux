DESCRIPTION = "Init script to read the legacy FRU data from EEPROM \
		and load dtbo and bin files for zynqmp devices"
SUMMARY = "Init script to read the legacy FRU data from EEPROM \
		and load dtbo and bin files for zynqmp devies"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://board-fpga-autoload.sh"

inherit update-rc.d

RDEPENDS_${PN} += "fpga-manager-script"

INITSCRIPT_NAME = "board-fpga-autoload.sh"
INITSCRIPT_PARAMS = "start 99 S ."

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = ".*"

do_install () {
    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/board-fpga-autoload.sh ${D}${sysconfdir}/init.d/
}

FILES_${PN} = "${sysconfdir}/init.d/board-fpga-autoload.sh"
