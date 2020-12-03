DESCRIPTION = "fru-print"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE.txt;md5=cbe895ca02dfa53a3d54f227d1b1967c"

RDEPENDS_${PN} = "python3-core python3-pyyaml"
inherit python3-dir

REPO = "git://github.com/genotrance/fru-tool.git;protocol=https"
BRANCH = "master"
SRCREV = "96f02c8897f89e297dfde88f5ad266163d166168"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

SRC_URI += " \
    file://fru-print.py \
    file://0001-fru.py-Modifying-for-xilinx-specific-specs.patch \
    "

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}/
    install -d ${D}${bindir}/
    install -m 0755 ${S}/fru.py ${D}${PYTHON_SITEPACKAGES_DIR}/
    install -m 0755 ${WORKDIR}/fru-print.py ${D}${bindir}/
}

FILES_${PN} += "${PYTHON_SITEPACKAGES_DIR}/fru.py ${bindir}/fru-print.py"
