DESCRIPTION = "User space power off support for ultra96"
SUMMARY = "A mraa based power button montior to display power-off message on LCD"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://ultra96-power-button-check.c;beginline=1;endline=29;md5=3d06ba301eafa825e49f161970efa3d1"

SRC_URI = " \
	file://Makefile \
	file://ultra96-power-button.sh \
	file://ultra96-power-button-check.c \
	file://groove-rgb-lcd.py \
	"

inherit update-rc.d

S = "${WORKDIR}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_ultra96-zynqmp = "ultra96-zynqmp"

INITSCRIPT_NAME = "ultra96-power-button.sh"
INITSCRIPT_PARAMS = "start 99 S ."

DEPENDS = "mraa"
RDEPENDS_${PN} = "mraa"

TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
	install -d ${D}/sbin
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ultra96-power-button-check ${D}/sbin
	install -m 0755 groove-rgb-lcd.py ${D}/sbin
	install -m 0755 ${S}/ultra96-power-button.sh ${D}${sysconfdir}/init.d/ultra96-power-button.sh
}
