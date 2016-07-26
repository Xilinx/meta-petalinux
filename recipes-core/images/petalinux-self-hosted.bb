DESCRIPTION = "OSL image definition for self hosted Xilinx boards"
LICENSE = "MIT"

require petalinux-image-common.inc

IMAGE_INSTALL += " \
    packagegroup-self-hosted \
    "

IMAGE_LINGUAS = " "

