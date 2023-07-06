BRANCH ?= "xlnx-rebase-v1.20.5"
REPO   ?= "git://github.com/Xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.20.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
"

SRCREV_gstreamer-xlnx = "a8ee09a92c52c4553ff10cc02d6855a5944b28fa"
SRCREV_FORMAT = "gstreamer-xlnx"
