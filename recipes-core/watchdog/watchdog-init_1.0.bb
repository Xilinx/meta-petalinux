#
# This recipe installs start script watchdog.sh in /etc/init.d
#

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/watchdog-init.sh;beginline=3;endline=31;md5=3da9d00ad07c09b1c5d373fa9a25b0ed"

SRC_URI = "\
	file://watchdog-init.sh \
	"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

do_install() {
	install -Dm 0755 ${WORKDIR}/watchdog-init.sh ${D}${sysconfdir}/init.d/watchdog-init
}

FILES_${PN} = "$(datadir)/* ${sysconfdir}/*"

