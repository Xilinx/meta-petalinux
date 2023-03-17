BRANCH ?= "xlnx-rebase-v1.20.5"
REPO   ?= "git://github.com/Xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.20.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
"

SRCREV_gstreamer-xlnx = "69a099e701fd29118ef3af1569312a8f56f72606"
SRCREV_FORMAT = "gstreamer-xlnx"
