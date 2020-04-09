#
# This recipe installs start script watchdog.sh in /etc/init.d
#

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/watchdog-init.sh;beginline=3;endline=26;md5=4c5a34c2563a32257921e046334fbb6e"

SRC_URI = "\
	file://watchdog-init.sh \
	"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

do_install() {
	install -Dm 0755 ${WORKDIR}/watchdog-init.sh ${D}${sysconfdir}/init.d/watchdog-init
}

FILES_${PN} = "$(datadir)/* ${sysconfdir}/*"

