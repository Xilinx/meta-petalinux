SRCREV = "57292f7f367561ba7be828b704b7be88eb43e28e"
XEN_URI = "git://github.com/Xilinx/xen.git;protocol=https"
XEN_BRANCH = "xlnx_rebase_4.17"

PV .= "-xilinx+git${SRCPV}"

DEPENDS += "image-builder-native"
DEFAULT_PREFERENCE = "+1"
