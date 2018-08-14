XEN_REL = "4.9"
XEN_BRANCH = "stable-${XEN_REL}"

BRANCH = ""
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "c227fe68589bdfb36b85f7b78c034a40c95b9a30"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

require xen-xilinx.inc

DEFAULT_PREFERENCE = "+1"
