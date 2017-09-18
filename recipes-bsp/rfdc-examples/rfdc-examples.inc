LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/license.txt;md5=530190e8d7ebcdfeddbe396f3f20417f"

REPO ?= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ?= "release-2017.3"
SRCREV = "3c9f0cfde9307c2dc1a298f9f22d492601232821"

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
