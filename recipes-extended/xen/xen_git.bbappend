XEN_REL = "4.12"

BRANCH = "xilinx/release-2021.1"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "d6e886f693e79a0f75bfa3546022ed1db15464d6"
LIC_FILES_CHKSUM = "file://COPYING;md5=419739e325a50f3d7b4501338e44a4e5"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

require xen-xilinx.inc

DEFAULT_PREFERENCE = "+1"
