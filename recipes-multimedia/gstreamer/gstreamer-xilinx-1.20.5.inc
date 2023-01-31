BRANCH ?= "xlnx-rebase-v1.20.5"
REPO   ?= "git://github.com/Xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.20.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
"

SRCREV_gstreamer-xlnx = "e9e00a1aa55293035a1802f80f8a7ed9cd1f0d83"
SRCREV_FORMAT = "gstreamer-xlnx"
