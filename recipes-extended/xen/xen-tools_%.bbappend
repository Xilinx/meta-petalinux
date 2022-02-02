require xen-xilinx.inc

EXTRA_OECONF += " \
	--with-systemd-modules-load=${nonarch_libdir}/modules-load.d \
"
FILES:${PN}-xencommons += "\
	${nonarch_libdir}/modules-load.d/xen.conf \
"
do_install:append () {
	if [ -e ${D}/usr/lib/xen/bin/pygrub ]; then
		sed -i -e '1c#!/usr/bin/env python3' ${D}/usr/lib/xen/bin/pygrub
	fi
}
FILES:${PN} += "${libdir}/xen/bin/init-dom0less \
    ${libdir}/xen/bin/get_overlay \
    ${libdir}/xen/bin/get_overlay.sh \
"
