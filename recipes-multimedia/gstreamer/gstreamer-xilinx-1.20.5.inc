BRANCH ?= "xlnx-rebase-v1.20.5"
REPO   ?= "git://github.com/Xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.20.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
"

SRCREV_gstreamer-xlnx = "48eba62b98efe83b86cef38ee876e9f5b23f3397"
SRCREV_FORMAT = "gstreamer-xlnx"
