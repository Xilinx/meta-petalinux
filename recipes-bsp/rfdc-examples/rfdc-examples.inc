LICENSE = "BSD"
LIC_FILES_CHKSUM ="file://${WORKDIR}/git/license.txt;md5=c83c24ed6555ade24e37e6b74ade2629"

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2019.1"
SRCREV ??= "c53b24258d857065f45cfeca544b5f5a0eaf0feb"
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
