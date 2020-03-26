DESCRIPTION = "OSL image definition for Xilinx boards"
LICENSE = "MIT"

require petalinux-image-full.inc

IMAGE_INSTALL_append_zynqmpev = " gstreamer-vcu-notebooks"
IMAGE_INSTALL_append_versal = " aie-notebooks pm-notebooks openamp-demo-notebooks"
IMAGE_INSTALL_append_zynqmp = " openamp-demo-notebooks"
