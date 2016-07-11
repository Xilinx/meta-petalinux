require recipes-extended/xen/xen.inc

SRCREV = "${AUTOREV}"

XEN_REL="4.7"

PV = "${XEN_REL}.0+git${SRCPV}"

S = "${WORKDIR}/git"

SRC_URI = " \
    git://github.com/Xilinx/xen.git;protocol=https \
    "

SRC_URI[md5sum] = "5c244ba649faab65db00ae9ad54e2f00"
SRC_URI[sha256sum] = "0e31451ec62fafb6dc623f19bdc15ea400231127aca07bc27de8b69e01968995"

DEPENDS += "u-boot-mkimage-native"

EXTRA_OEMAKE += 'CROSS_COMPILE=${TARGET_PREFIX}'

XENIMAGE_KERNEL_LOADADDRESS ?= "0x5000000"

do_deploy_append() {
    if [ -f ${DEPLOYDIR}/xen-${MACHINE} ]; then
        uboot-mkimage -A arm64 -T kernel \
        -a ${XENIMAGE_KERNEL_LOADADDRESS} \
        -e ${XENIMAGE_KERNEL_LOADADDRESS} \
        -C none \
        -d ${DEPLOYDIR}/xen-${MACHINE} ${DEPLOYDIR}/xen.ub
    fi
}
