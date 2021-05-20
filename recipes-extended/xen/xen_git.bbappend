require xen-xilinx.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://example-passnet.cfg \
    file://example-pvnet.cfg \
    file://example-simple.cfg \
    file://passthrough-example-part.dts \
    "

FILES_${PN}_append = " \
    /etc/xen/example-passnet.cfg \
    /etc/xen/example-pvnet.cfg \
    /etc/xen/example-simple.cfg \
    /etc/xen/passthrough-example-part.dtb \
    "

RDEPENDS_${PN}-efi += "bash python3"

do_compile_append() {
    dtc -I dts -O dtb ${WORKDIR}/passthrough-example-part.dts -o ${WORKDIR}/passthrough-example-part.dtb
}

do_deploy_append() {
    # Mimic older behavior for compatibility
    if [ -f ${DEPLOYDIR}/xen-${MACHINE} ]; then
        ln -s xen-${MACHINE} ${DEPLOYDIR}/xen
    fi

    if [ -f ${DEPLOYDIR}/xen-${MACHINE}.gz ]; then
        ln -s xen-${MACHINE}.gz ${DEPLOYDIR}/xen.gz
    fi

    if [ -f ${DEPLOYDIR}/xen-${MACHINE}.efi ]; then
        ln -s xen-${MACHINE}.efi ${DEPLOYDIR}/xen.efi
    fi
}

do_install_append() {
    install -d -m 0755 ${D}/etc/xen
    install -m 0644 ${WORKDIR}/example-passnet.cfg ${D}/etc/xen/example-passnet.cfg
    install -m 0644 ${WORKDIR}/example-pvnet.cfg ${D}/etc/xen/example-pvnet.cfg
    install -m 0644 ${WORKDIR}/example-simple.cfg ${D}/etc/xen/example-simple.cfg

    install -m 0644 ${WORKDIR}/passthrough-example-part.dtb ${D}/etc/xen/passthrough-example-part.dtb
}
