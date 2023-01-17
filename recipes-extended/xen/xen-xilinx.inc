XEN_REL = "4.17"

BRANCH = "xlnx_rebase_4.17"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "57292f7f367561ba7be828b704b7be88eb43e28e"
LIC_FILES_CHKSUM = "file://COPYING;md5=d1a1e216f80b6d8da95fec897d0dbec9"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

DEFAULT_PREFERENCE = "+1"
