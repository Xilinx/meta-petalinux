BRANCH ?= "xlnx-rebase-v1.20.3"
REPO   ?= "git://github.com/Xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.20.3+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
"

SRCREV_gstreamer-xlnx = "d1e4ddc91334bc30db91e06fef0cab2cc0aa0d3f"
SRCREV_FORMAT = "gstreamer-xlnx"
