DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

ZYNQ_FEATURES = " \
    dev-pkgs \
    package-management \
    ptest-pkgs \
    splash \
    tools-debug \
    tools-profile \
    tools-sdk \
    tools-testapps \
    "

IMAGE_FEATURES_append_zynq += "${ZYNQ_FEATURES}"

IMAGE_FEATURES_append_zynqmp += " ${ZYNQ_FEATURES}"

IMAGE_INSTALL += " \
    packagegroup-petalinux \
    packagegroup-petalinux-qt \
    packagegroup-petalinux-opencv \
    packagegroup-petalinux-x11 \
    "

IMAGE_INSTALL_append_zynq += " \
    packagegroup-petalinux-self-hosted \
    "

IMAGE_INSTALL_append_zynqmp += " \
    packagegroup-benchmarks \
    packagegroup-petalinux-gstreamer \
    packagegroup-petalinux-audio \
    packagegroup-petalinux-self-hosted \
    ${@bb.utils.contains('DISTRO_FEATURES', 'xen', 'packagegroup-petalinux-xen', '', d)} \
    "
