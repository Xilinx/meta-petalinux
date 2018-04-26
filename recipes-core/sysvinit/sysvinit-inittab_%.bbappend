FILESEXTRAPATHS_prepend  := "${THISDIR}/files:"

do_install_append() {
	sed -i s#/sbin/getty#/bin/start_getty#g ${D}${sysconfdir}/inittab

}
