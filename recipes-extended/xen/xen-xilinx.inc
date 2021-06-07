XEN_REL = "4.14"

BRANCH = "xilinx/release-2021.1"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "4bd2da58b5b008f77429007a307b658db9c0f636"
LIC_FILES_CHKSUM = "file://COPYING;md5=419739e325a50f3d7b4501338e44a4e5"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

DEFAULT_PREFERENCE = "+1"

