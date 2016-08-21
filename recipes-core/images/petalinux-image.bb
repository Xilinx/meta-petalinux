DESCRIPTION = "An image containing the full set of packages in the Petalinux distro."
LICENSE = "MIT"

require petalinux-image-common.inc

IMAGE_INSTALL += " \
    packagegroup-petalinux \
"

IMAGE_INSTALL_append_zynqmp += "packagegroup-benchmarks"
