BRANCH ?= "xlnx-rebase-v1.18.5"
REPO ?= "git://github.com/Xilinx/gst-plugins-good.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.18.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    file://0001-qt-include-ext-qt-gstqtgl.h-instead-of-gst-gl-gstglf.patch \
"

SRCREV_base = "bb03e48ce8fb38bc8bc9c344073dce8249443f3f"
SRCREV_FORMAT = "base"

S = "${WORKDIR}/git"
