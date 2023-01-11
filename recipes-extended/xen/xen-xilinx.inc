XEN_REL = "4.17"

BRANCH = "xlnx_rebase_4.17"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "1adb47a91515d5d779b8b3d5fd0c60afbdb3dc3c"
LIC_FILES_CHKSUM = "file://COPYING;md5=d1a1e216f80b6d8da95fec897d0dbec9"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

DEFAULT_PREFERENCE = "+1"
