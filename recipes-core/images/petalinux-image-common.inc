inherit core-image
inherit plnx-image
inherit image_types_plnx

# Skip /boot when generating a cpio, jffs2
PLNX_IMAGE_CPIO_SKIP += "! -path './boot/*'"
PLNX_IMAGE_JFFS2_SKIP += "! -path './boot/*'"
PLNX_IMAGE_UBI_SKIP += "! -path './boot/*'"

SSH_SERVER_DEFAULT ?= " ssh-server-openssh"
SSH_SERVER_DEFAULT:microblaze ?= " ssh-server-dropbear"
COMMON_FEATURES ?= "${SSH_SERVER_DEFAULT} hwcodecs"

IMAGE_FEATURES += "${COMMON_FEATURES}"

SYSTEMD_DEFAULT_TARGET = "${@bb.utils.contains_any('IMAGE_INSTALL', \
    [ 'packagegroup-petalinux-x11', 'packagegroup-petalinux-weston' ], \
    'graphical.target', 'multi-user.target', d)}"

COMMON_INSTALL = " \
    tcf-agent \
    mtd-utils \
    bridge-utils \
    can-utils \
    pciutils \
    kernel-modules \
    nfs-utils \
    nfs-utils-client \
    linux-xlnx-udev-rules \
    "

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    ${COMMON_INSTALL} \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

#Create devfs entries for initramfs(bundle) image
USE_DEVFS = "${@'0' if d.getVar('INITRAMFS_IMAGE_BUNDLE') == '1' else '1'}"
IMAGE_DEVICE_TABLES:append = " files/plnx_dev_table.txt"

# If meta-xilinx-tools is available, require libdfx
LIBDFX_RECIPE = "${@'libdfx' if 'xilinx-tools' in d.getVar('BBFILE_COLLECTIONS').split() else ''}"

INSTALL_ZYNQ_ZYNQMP_VERSAL = " \
    fpga-manager-script \
    htop \
    iperf3 \
    meson \
    u-boot-tools \
    "

COMMON_INSTALL:append:zynqmp = " ${INSTALL_ZYNQ_ZYNQMP_VERSAL} hellopm ${LIBDFX_RECIPE}"
COMMON_INSTALL:append:zynq = " ${INSTALL_ZYNQ_ZYNQMP_VERSAL}"
COMMON_INSTALL:append:versal = " ${INSTALL_ZYNQ_ZYNQMP_VERSAL} ${LIBDFX_RECIPE}"

CORE_IMAGE_EXTRA_INSTALL:append:ultra96-zynqmp = " packagegroup-base-extended"

IMAGE_LINGUAS = " "
