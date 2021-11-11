require xen-xilinx.inc

do_install:append () {
	if [ -e ${D}/usr/lib/xen/bin/pygrub ]; then
		sed -i -e '1c#!/usr/bin/env python3' ${D}/usr/lib/xen/bin/pygrub
	fi
}

