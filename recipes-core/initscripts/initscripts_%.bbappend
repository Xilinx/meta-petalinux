FILESEXTRAPATHS:prepend:zynqmp := "${THISDIR}/files:"
SRC_URI:append:zynqmp := " \
	file://reboot_init.sh \
	file://set_reboot \
	"

MASKED_SCRIPTS:append:zynqmp := "reboot_init"

RREPLACES:${PN}-functions = "lsbinitscripts"

do_install:append:zynqmp() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/set_reboot ${D}${bindir}/set_reboot
	install -m 0644 ${WORKDIR}/reboot_init.sh ${D}${sysconfdir}/init.d
	update-rc.d -r ${D} reboot_init.sh start 01 S 6 .
}

PACKAGE_ARCH:zynqmp = "${SOC_FAMILY_ARCH}"
