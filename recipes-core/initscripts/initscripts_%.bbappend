FILESEXTRAPATHS_prepend_zynqmp := "${THISDIR}/files:"
SRC_URI_append_zynqmp := " \
	file://reboot_init.sh \
	file://set_reboot \
	"

MASKED_SCRIPTS_append_zynqmp := "reboot_init"

RREPLACES_${PN}-functions = "lsbinitscripts"

do_install_append_zynqmp() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/set_reboot ${D}${bindir}/set_reboot
	install -m 0644 ${WORKDIR}/reboot_init.sh ${D}${sysconfdir}/init.d
	update-rc.d -r ${D} reboot_init.sh start 01 S 6 .
}
