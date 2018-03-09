FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://monitor-hotplug.sh"
SRC_URI += "file://99-monitor-hotplug.rules"

do_install_append() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/monitor-hotplug.sh ${D}${bindir}

	install -d ${D}${sysconfdir}/udev/rules.d
	install -m 0644 ${WORKDIR}/99-monitor-hotplug.rules ${D}${sysconfdir}/udev/rules.d/local.rules
}
