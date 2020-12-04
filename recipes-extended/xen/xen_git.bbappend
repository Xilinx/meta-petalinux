XEN_REL = "4.14"

BRANCH = "xilinx/release-2020.2"
REPO = "git://github.com/Xilinx/xen.git;protocol=https"
SRCREV = "dfa58d1a3f0db395f2c8799419cf6fa537eb2aeb"
LIC_FILES_CHKSUM = "file://COPYING;md5=4295d895d4b5ce9d070263d52f030e49"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = "${REPO};${BRANCHARG}"

DEPENDS += "image-builder-native"

require xen-xilinx.inc

DEFAULT_PREFERENCE = "+1"
