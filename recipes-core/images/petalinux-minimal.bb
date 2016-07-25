DESCRIPTION = "OSL image definition for Xilinx boards"
LICENSE = "MIT"

inherit core-image

IMAGE_FEATURES += " \
    ssh-server-dropbear \
    "
ZYNQ_TOOLS = " \
    tools-debug \
    tools-profile \
    "

IMAGE_FEATURES_append_zynq += " ${ZYNQ_TOOLS}"

IMAGE_FEATURES_append_zynqmp += " ${ZYNQ_TOOLS}"

IMAGE_INSTALL += " \
    packagegroup-core-boot \
    i2c-tools \
    openssh-sftp-server \
    tcf-agent \
    usbutils \
    ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

IMAGE_LINGUAS = " "
