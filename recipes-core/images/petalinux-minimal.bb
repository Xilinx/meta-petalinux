DESCRIPTION = "OSL image definition for Xilinx boards"
LICENSE = "MIT"

inherit core-image

IMAGE_FEATURES += " \
    ssh-server-dropbear \
    tools-debug \
    tools-profile \
    "

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
