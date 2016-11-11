inherit core-image

COMMON_FEATURES = " \
    ssh-server-dropbear \
    "
IMAGE_FEATURES += "${COMMON_FEATURES}"

COMMON_INSTALL = " \
    openssh-sftp-server \
    tcf-agent \
    mtd-utils \
    bridge-utils \
    canutils \
    pciutils \
    kernel-modules \
    "

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    ${COMMON_INSTALL} \
    ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

IMAGE_LINGUAS = " "
