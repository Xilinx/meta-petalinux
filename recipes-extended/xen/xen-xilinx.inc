XEN_REL = "4.14"

BRANCH = "xilinx/release-2021.2"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "8f152179cefedd6f2ba0f210e90aa0390aac27f0"
LIC_FILES_CHKSUM = "file://COPYING;md5=419739e325a50f3d7b4501338e44a4e5"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

DEFAULT_PREFERENCE = "+1"

