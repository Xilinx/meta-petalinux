XEN_REL = "4.12"

BRANCH = "xilinx/release-2020.1"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "775913b2892a8c9b08dfa3db81b1cf93798399aa"
LIC_FILES_CHKSUM = "file://COPYING;md5=4295d895d4b5ce9d070263d52f030e49"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

require xen-xilinx.inc

DEFAULT_PREFERENCE = "+1"
