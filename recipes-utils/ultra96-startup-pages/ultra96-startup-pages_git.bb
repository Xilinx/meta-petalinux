DESCRIPTION = "Webapp that can be accessed by connecting to the Ultra96 board using AP address and boards MAC address"
SUMMARY = "Webapp that provides support for Ultra96 devices"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=a768baea9d204ad586e989c92a2afb31"

SRC_URI = "git://github.com/Xilinx/ultra96-startup-pages.git;protocol=https \
	   file://ultra96-startup-page.sh \
	   file://launch-ultra96-startup-page.desktop \
	   file://launch-ultra96-startup-page.sh \
	   file://connman_settings \
"
inherit update-rc.d

DEPENDS += "rsync-native"
RDEPENDS_${PN} = "ace-cloud-editor chromium python3-itsdangerous python3-markupsafe python3-jinja2 python3-werkzeug python3-flask bash connman connman-client connman-tools"

INITSCRIPT_NAME = "ultra96-startup-page.sh"
INITSCRIPT_PARAMS = "start 99 S ."

PV = "1.0+git${SRCPV}"
SRCREV = "9a892575be16534879fcdc333b0714b4839a869b"

FILES_${PN} += "${datadir}/ultra96-startup-pages"
FILES_${PN} += "${base_sbindir}/ /var/lib/connman/"

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

    install -d ${D}/var/lib/connman
    install -m 0755 ${WORKDIR}/connman_settings ${D}/var/lib/connman/settings

}


