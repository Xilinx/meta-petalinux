require xen-xilinx.inc

do_install:append () {
	if [ find ${D}/usr/lib/xen/bin/ -name "pygrub" &> /dev/null ]; then
		sed -i -e '1c#!/usr/bin/env python3' ${D}/usr/lib/xen/bin/pygrub
	fi
}

