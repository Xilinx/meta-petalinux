#
# This recipe installs start script watchdog.sh in /etc/init.d
#

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/watchdog.sh;beginline=3;endline=31;md5=3da9d00ad07c09b1c5d373fa9a25b0ed"

SRC_URI = "\
	file://watchdog.sh \
	"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

inherit update-rc.d

INITSCRIPT_NAME = "watchdog.sh"
INITSCRIPT_PARAMS = "start 99 S ."

do_install() {
	install -Dm 0755 ${WORKDIR}/watchdog.sh ${D}${sysconfdir}/init.d/watchdog.sh
}

FILES_${PN} = "$(datadir)/* ${sysconfdir}/*"

