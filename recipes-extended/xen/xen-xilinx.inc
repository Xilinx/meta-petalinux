XEN_REL = "4.16"

BRANCH = "xlnx_rebase_4.16"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "47ce40314bbec31b683da56d007d14603f002d0c"
LIC_FILES_CHKSUM = "file://COPYING;md5=419739e325a50f3d7b4501338e44a4e5"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

DEFAULT_PREFERENCE = "+1"
