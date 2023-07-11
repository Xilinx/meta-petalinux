SRCREV = "f7568f4d2f84016d7a98320bb6ea9a055c8df333"
XEN_URI = "git://github.com/Xilinx/xen.git;protocol=https"
XEN_BRANCH = "xlnx_rebase_4.17"

PV .= "-xilinx+git${SRCPV}"

DEPENDS += "image-builder-native"
DEFAULT_PREFERENCE = "+1"
