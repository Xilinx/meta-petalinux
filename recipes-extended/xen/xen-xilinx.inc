XEN_REL = "4.16"

BRANCH = "xlnx_rebase_4.16"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "198a86e18e14dc2ef8afcbdc8441c6b0b9c32d46"
LIC_FILES_CHKSUM = "file://COPYING;md5=419739e325a50f3d7b4501338e44a4e5"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

DEFAULT_PREFERENCE = "+1"

PREFERRED_VERSION_xen = "4.16"
PREFERRED_VERSION_xen-tools = "4.16"
