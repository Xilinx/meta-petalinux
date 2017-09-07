XEN_REL = "4.9"
XEN_BRANCH = "stable-${XEN_REL}"

BRANCH = "xilinx/${XEN_BRANCH}"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "ea381e4fb2fe7ced6ae35c805f871b6ea228084f"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

require xen-xilinx.inc

DEFAULT_PREFERENCE = "+1"
