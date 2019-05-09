LICENSE = "BSD"
LIC_FILES_CHKSUM="file://${WORKDIR}/git/license.txt;md5=2c0aabb3d600bd7043d0db0b47ee2a4b"

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2019.1"
SRCREV ??= "324e7b58ecc9ea06a929fb545d73565cafb9989a"
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
