BRANCH ?= "xlnx-rebase-v1.18.5"
REPO ?= "git://github.com/Xilinx/gst-plugins-base.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.18.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    file://0001-ENGR00312515-get-caps-from-src-pad-when-query-caps.patch \
    file://0002-ssaparse-enhance-SSA-text-lines-parsing.patch \
    file://0003-viv-fb-Make-sure-config.h-is-included.patch \
    file://0004-glimagesink-Downrank-to-marginal.patch \
"

SRCREV_base = "ce156424eb9cbb66dc1aa446c4be6372d3ff5792"
SRCREV_FORMAT = "base"

PACKAGECONFIG:append = " opus"

S = "${WORKDIR}/git"
