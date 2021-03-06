FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://example-passnet.cfg \
    file://example-pvnet.cfg \
    file://example-simple.cfg \
    file://passthrough-example-part.dts \
    "

FILES_${PN}-xl_append = " \
    /etc/xen/example-passnet.cfg \
    /etc/xen/example-pvnet.cfg \
    /etc/xen/example-simple.cfg \
    /etc/xen/passthrough-example-part.dtb \
    "

do_compile_append() {
    dtc -I dts -O dtb ${WORKDIR}/passthrough-example-part.dts -o ${WORKDIR}/passthrough-example-part.dtb
}

do_install_append() {
    install -d -m 0755 ${D}/etc/xen
    install -m 0644 ${WORKDIR}/example-passnet.cfg ${D}/etc/xen/example-passnet.cfg
    install -m 0644 ${WORKDIR}/example-pvnet.cfg ${D}/etc/xen/example-pvnet.cfg
    install -m 0644 ${WORKDIR}/example-simple.cfg ${D}/etc/xen/example-simple.cfg

    install -m 0644 ${WORKDIR}/passthrough-example-part.dtb ${D}/etc/xen/passthrough-example-part.dtb
}


