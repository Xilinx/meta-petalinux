inherit core-image autologin

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

FEATURE_PACKAGES_petalinux-base ?= "packagegroup-petalinux"
FEATURE_PACKAGES_petalinux-x11 ?= "packagegroup-petalinux-x11"
FEATURE_PACKAGES_petalinux-x11[optional] ?= "1"
FEATURE_PACKAGES_petalinux-self-hosted ?= "packagegroup-petalinux-self-hosted"
FEATURE_PACKAGES_petalinux-self-hosted[optional] ?= "1"
FEATURE_PACKAGES_petalinux-qt ?= "packagegroup-petalinux-qt"
FEATURE_PACKAGES_petalinux-qt[optional] ?= "1"
FEATURE_PACKAGES_petalinux-opencv ?= "packagegroup-petalinux-opencv"
FEATURE_PACKAGES_petalinux-opencv[optional] ?= "1"
FEATURE_PACKAGES_petalinux-benchmarks ?= "packagegroup-petalinux-benchmarks"
FEATURE_PACKAGES_petalinux-benchmarks[optional] ?= "1"
FEATURE_PACKAGES_petalinux-gstreamer ?= "packagegroup-petalinux-gstreamer"
FEATURE_PACKAGES_petalinux-gstreamer[optional] ?= "1"
FEATURE_PACKAGES_petalinux-audio ?= "packagegroup-petalinux-audio"
FEATURE_PACKAGES_petalinux-audio[optional] ?= "1"
FEATURE_PACKAGES_petalinux-xen ?= "packagegroup-petalinux-xen"
FEATURE_PACKAGES_petalinux-xen[optional] ?= "1"
FEATURE_PACKAGES_petalinux-openamp ?= "packagegroup-petalinux-openamp"
FEATURE_PACKAGES_petalinux-openamp[optional] ?= "1"
