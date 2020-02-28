XEN_REL = "4.12"

BRANCH = "master"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "997d6248a9ae932d0dbaac8d8755c2b15fec25dc"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

require xen-xilinx.inc

DEFAULT_PREFERENCE = "+1"
