XEN_REL = "4.16"

BRANCH = "xlnx_rebase_4.16"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "0b2f3de08b082287d4a6565900e34d64add40b89"
LIC_FILES_CHKSUM = "file://COPYING;md5=419739e325a50f3d7b4501338e44a4e5"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

DEFAULT_PREFERENCE = "+1"
