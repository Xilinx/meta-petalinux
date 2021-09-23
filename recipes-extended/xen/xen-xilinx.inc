XEN_REL = "4.14"

BRANCH = "xlnx_rebase_4.14"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "82d4b73e0acd2d318f46c3a7a2d332456408f549"
LIC_FILES_CHKSUM = "file://COPYING;md5=419739e325a50f3d7b4501338e44a4e5"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

DEFAULT_PREFERENCE = "+1"

