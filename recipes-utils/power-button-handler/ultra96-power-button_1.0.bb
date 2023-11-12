DESCRIPTION = "User space power off support for ultra96"
SUMMARY = "A mraa based power button montior to display power-off message on LCD"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://ultra96-power-button-check.c;beginline=1;endline=25;md5=1c552ff04522a3bd79001dbc21152402"

SRC_URI = " \
	file://Makefile \
	file://ultra96-power-button.sh \
	file://ultra96-power-button-check.c \
	file://groove-rgb-lcd.py \
	"

inherit update-rc.d

S = "${WORKDIR}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:ultra96-zynqmp = "${MACHINE}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

INITSCRIPT_NAME = "ultra96-power-button.sh"
INITSCRIPT_PARAMS = "start 99 S ."

DEPENDS = "mraa"
RDEPENDS:${PN} = "mraa"

TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
	install -d ${D}${base_sbindir}
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ultra96-power-button-check ${D}${base_sbindir}
	install -m 0755 groove-rgb-lcd.py ${D}${base_sbindir}
	install -m 0755 ${S}/ultra96-power-button.sh ${D}${sysconfdir}/init.d/ultra96-power-button.sh
}

FILES:${PN} += "${base_sbindir}"
