DEPENDS += "u-boot-mkimage-native"
DEPENDS += "dtc-native"
RDEPENDS_${PN}-efi += "bash python3"

XENIMAGE_KERNEL_LOADADDRESS ?= "0x6000000"

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

# Force this to rebuild each time
deltask do_deploy_setscene
deltask do_populate_sysroot_setscene
