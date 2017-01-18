FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    git://github.com/Xilinx/xen.git;protocol=https;nobranch=1 \
    file://example-passnet.cfg \
    file://example-pvnet.cfg \
    file://example-simple.cfg \
    file://passthrough-example-part.dts \
    "

SRCREV = "07df4864ce2181147aacf41b6426e8c73306be55"

S = "${WORKDIR}/git"

FILES_${PN}-xl_append = " \
    /etc/xen/example-passnet.cfg \
    /etc/xen/example-pvnet.cfg \
    /etc/xen/example-simple.cfg \
    /etc/xen/passthrough-example-part.dtb \
    "

DEPENDS += "u-boot-mkimage-native"

XENIMAGE_KERNEL_LOADADDRESS ?= "0x5000000"

do_compile_append() {
    dtc -I dts -O dtb ${WORKDIR}/passthrough-example-part.dts -o ${WORKDIR}/passthrough-example-part.dtb
}

do_deploy_append() {
    if [ -f ${DEPLOYDIR}/xen-${MACHINE} ]; then
        uboot-mkimage -A arm64 -T kernel \
        -a ${XENIMAGE_KERNEL_LOADADDRESS} \
        -e ${XENIMAGE_KERNEL_LOADADDRESS} \
        -C none \
        -d ${DEPLOYDIR}/xen-${MACHINE} ${DEPLOYDIR}/xen.ub
    fi
}

do_install_append() {
    install -d -m 0755 ${D}/etc/xen
    install -m 0644 ${WORKDIR}/example-passnet.cfg ${D}/etc/xen/example-passnet.cfg
    install -m 0644 ${WORKDIR}/example-pvnet.cfg ${D}/etc/xen/example-pvnet.cfg
    install -m 0644 ${WORKDIR}/example-simple.cfg ${D}/etc/xen/example-simple.cfg

    install -m 0644 ${WORKDIR}/passthrough-example-part.dtb ${D}/etc/xen/passthrough-example-part.dtb
}
