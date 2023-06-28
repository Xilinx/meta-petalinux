BRANCH ?= "xlnx-rebase-v1.20.5"
REPO   ?= "git://github.com/Xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.20.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
"

SRCREV_gstreamer-xlnx = "74090c99e6b4c7c243169a36ded8bdbc80975678"
SRCREV_FORMAT = "gstreamer-xlnx"
