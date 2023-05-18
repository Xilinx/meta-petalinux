SRCREV = "f8350485d2a841785ed91c1aa082cd8666c86a97"
XEN_URI = "git://github.com/Xilinx/xen.git;protocol=https"
XEN_BRANCH = "xlnx_rebase_4.17"

PV .= "-xilinx+git${SRCPV}"

DEPENDS += "image-builder-native"
DEFAULT_PREFERENCE = "+1"
