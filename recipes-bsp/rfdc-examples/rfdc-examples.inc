LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/license.txt;md5=2a8d7a7f870f65ce77e8ccd8150cce10"

REPO ??= "git://github.com/xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2018.2"
SRCREV ??= "6e82c0183bdfb9c6838966b9b87ef8385ba35504"
COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

PACKAGE_ARCH = "${SOC_FAMILY}${SOC_VARIANT}"

DEPENDS = "rfdc"
RDEPENDS_${PN} = "rfdc"

PACKAGES = "${PN}-dbg ${PN}"

S = "${WORKDIR}/git/XilinxProcessorIPLib/drivers/rfdc/examples"

FLAG = ""
FLAG_zcu111-zynqmp = "-DXPS_BOARD_ZCU111"

do_compile_prepend () {
    cp ${S}/Makefile.Linux ${S}/Makefile
}
