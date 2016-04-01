DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

inherit core-image

ZYNQ_TOOLS = " \
    tools-debug \
    tools-profile \
    "

IMAGE_FEATURES_append_zynq += " ${ZYNQ_TOOLS}"

IMAGE_FEATURES_append_zynqmp += " ${ZYNQ_TOOLS}"

IMAGE_INSTALL += " \
    packagegroup-core-boot \
    packagegroup-petalinux \
    ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
    ${CORE_IMAGE_EXTRA_INSTALL} \
"

IMAGE_LINGUAS = " "
