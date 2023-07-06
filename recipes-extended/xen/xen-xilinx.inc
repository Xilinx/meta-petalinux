SRCREV = "0378a38cd00e09a085d29efd08581f5c12fb50d2"
XEN_URI = "git://github.com/Xilinx/xen.git;protocol=https"
XEN_BRANCH = "xlnx_rebase_4.17"

PV .= "-xilinx+git${SRCPV}"

DEPENDS += "image-builder-native"
DEFAULT_PREFERENCE = "+1"
