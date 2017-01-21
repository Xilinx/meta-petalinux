DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

IMAGE_INSTALL += " \
    packagegroup-petalinux \
    packagegroup-petalinux-qt \
    packagegroup-petalinux-opencv \
    packagegroup-petalinux-x11 \
    "

IMAGE_INSTALL_append_zynq += " \
    packagegroup-core-tools-profile \
    "

IMAGE_INSTALL_append_zynqmp += " \
    packagegroup-benchmarks \
    packagegroup-core-tools-profile \
    packagegroup-petalinux-gstreamer \
    "
