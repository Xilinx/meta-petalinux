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

DEPENDS += "u-boot-mkimage-native"
DEPENDS += "dtc-native"
RDEPENDS_${PN}-efi += "bash python"

XENIMAGE_KERNEL_LOADADDRESS ?= "0x6000000"

do_compile_append() {
    dtc -I dts -O dtb ${WORKDIR}/passthrough-example-part.dts -o ${WORKDIR}/passthrough-example-part.dtb
}

do_deploy() {
    install -d ${DEPLOYDIR}

    if [ -f ${D}/boot/xen ]; then
        install -m 0644 ${D}/boot/xen ${DEPLOYDIR}/xen
    fi

    if [ -f ${D}/boot/xen.gz ]; then
        install -m 0644 ${D}/boot/xen.gz ${DEPLOYDIR}/xen.gz
    fi

    if [ -f ${D}/usr/lib64/efi/xen.efi ]; then
        install -m 0644 ${D}/usr/lib64/efi/xen.efi ${DEPLOYDIR}/xen.efi
    fi

    # Install the flask policy in the deploy directory if it exists
    if [ -f ${D}/boot/${FLASK_POLICY_FILE} ]; then
        install -m 0644 ${D}/boot/${FLASK_POLICY_FILE} ${DEPLOYDIR}
        ln -sf ${FLASK_POLICY_FILE} ${DEPLOYDIR}/xenpolicy
    fi

    if [ -f ${DEPLOYDIR}/xen ]; then
        uboot-mkimage -A arm64 -T kernel \
        -a ${XENIMAGE_KERNEL_LOADADDRESS} \
        -e ${XENIMAGE_KERNEL_LOADADDRESS} \
        -C none \
        -d ${DEPLOYDIR}/xen ${DEPLOYDIR}/xen.ub
    fi
}

addtask deploy after do_populate_sysroot

do_install_append() {
    install -d -m 0755 ${D}/etc/xen
    install -m 0644 ${WORKDIR}/example-passnet.cfg ${D}/etc/xen/example-passnet.cfg
    install -m 0644 ${WORKDIR}/example-pvnet.cfg ${D}/etc/xen/example-pvnet.cfg
    install -m 0644 ${WORKDIR}/example-simple.cfg ${D}/etc/xen/example-simple.cfg

    install -m 0644 ${WORKDIR}/passthrough-example-part.dtb ${D}/etc/xen/passthrough-example-part.dtb
}

# Force this to rebuild each time
deltask do_deploy_setscene
deltask do_populate_sysroot_setscene
