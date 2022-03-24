BRANCH ?= "xlnx-rebase-v1.18.5"
REPO ?= "git://github.com/Xilinx/gst-plugins-good.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.18.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    file://0001-qt-include-ext-qt-gstqtgl.h-instead-of-gst-gl-gstglf.patch \
"

SRCREV_base = "154293d83380426645db6719526b4e80b8706bd4"
SRCREV_FORMAT = "base"

S = "${WORKDIR}/git"
