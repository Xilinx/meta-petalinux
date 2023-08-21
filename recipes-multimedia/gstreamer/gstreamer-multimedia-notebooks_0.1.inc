BRANCH ?= "master"
REPO   ?= "git://github.com/Xilinx/multimedia-notebooks.git;protocol=https"
SRCREV ?= "2c808dbb542c7e9dc4c0222686bc32210b2b0303"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

PV .= "+git${SRCPV}"
