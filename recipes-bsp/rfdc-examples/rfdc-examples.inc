LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/license.txt;md5=5e45a102b6cde936e15c44e3c59ac810"

REPO ?= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ?= "release-2017.4"
SRCREV = "77448ae629133607b66e747c4baaa7677dc1123d"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = "rfdc"
RDEPENDS_${PN} = "rfdc"

PACKAGES = "${PN}-dbg ${PN}"

S = "${WORKDIR}/git/XilinxProcessorIPLib/drivers/rfdc/examples"

do_compile_prepend () {
    cp ${S}/Makefile.Linux ${S}/Makefile
}
