SRCREV = "e29ecc8affaa25516b4b14c4b16bc570276ce781"
XEN_URI = "git://github.com/Xilinx/xen.git;protocol=https"
XEN_BRANCH = "xlnx_rebase_4.17"

PV .= "-xilinx+git${SRCPV}"

DEPENDS += "image-builder-native"
DEFAULT_PREFERENCE = "+1"
