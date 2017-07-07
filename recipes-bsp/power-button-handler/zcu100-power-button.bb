DESCRIPTION = "User space power off support for zcu100"
LICENSE = "Proprietary"

SRC_URI = " \
	file://Makefile \
	file://zcu100-power-button.sh \
	file://zcu100-power-button-check.c \
	"

LIC_FILES_CHKSUM = "file://zcu100-power-button-check.c;beginline=1;endline=36;md5=dbd161723b76c19ede42808228ad4fd8"

inherit update-rc.d

S = "${WORKDIR}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

INITSCRIPT_NAME = "zcu100-power-button.sh"
INITSCRIPT_PARAMS = "start 99 S ."

DEPENDS = "mraa"

TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
	install -d ${D}/sbin
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 zcu100-power-button-check ${D}/sbin
	install -m 0755 ${S}/zcu100-power-button.sh ${D}${sysconfdir}/init.d/zcu100-power-button.sh
}
