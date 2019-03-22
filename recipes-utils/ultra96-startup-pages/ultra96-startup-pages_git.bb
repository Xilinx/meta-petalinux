DESCRIPTION = "Webapp that can be accessed by connecting to the Ultra96 board using AP address and boards MAC address"
SUMMARY = "Webapp that provides support for Ultra96 devices"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=aac230823156ac80a4a57aeddc17f496"

SRC_URI = "git://github.com/Xilinx/ultra96-startup-pages.git;protocol=https \
	   file://ultra96-startup-page.sh \
	   file://launch-ultra96-startup-page.desktop \
	   file://launch-ultra96-startup-page.sh \
"
inherit update-rc.d

DEPENDS += "rsync-native"
RDEPENDS_${PN} = "ace-cloud-editor chromium python-itsdangerous python-markupsafe python-jinja2 python-werkzeug python-flask bash"

INITSCRIPT_NAME = "ultra96-startup-page.sh"
INITSCRIPT_PARAMS = "start 99 S ."

PV = "1.0+git${SRCPV}"
SRCREV = "141e4506c15440ce207030168972d0ec05e6838f"

FILES_${PN} += "${datadir}/ultra96-startup-pages"
FILES_${PN} += "${base_sbindir}/"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_ultra96-zynqmp = "ultra96-zynqmp"

S = "${WORKDIR}/git"

do_install () {
    install -d ${D}${datadir}/ultra96-startup-pages
    rsync -r --exclude=".*" ${S}/* ${D}${datadir}/ultra96-startup-pages

    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/ultra96-startup-page.sh ${D}${sysconfdir}/init.d/ultra96-startup-page.sh

    install -d ${D}${base_sbindir}/
    install -m 0755 ${WORKDIR}/launch-ultra96-startup-page.sh ${D}${base_sbindir}/launch-ultra96-startup-page.sh
    install -m 0755 ${WORKDIR}/launch-ultra96-startup-page.desktop ${D}${base_sbindir}/launch-ultra96-startup-page.desktop

}


