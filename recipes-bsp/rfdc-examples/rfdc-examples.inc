LICENSE = "BSD"
LIC_FILES_CHKSUM="file://license.txt;md5=3a6e22aebf6516f0f74a82e1183f74f8"

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "master-rel-2020.2"
SRCREV ??= "08b9f4304d1634ed632f4276d603d834940fd55a"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp-dr = "zynqmp-dr"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

DEPENDS = "rfdc"
RDEPENDS_${PN} = "rfdc"

PACKAGES = "${PN}-dbg ${PN}"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

FLAG = ""
FLAG_zcu111-zynqmp = "-DXPS_BOARD_ZCU111"

RFDC_SUBDIR = "XilinxProcessorIPLib/drivers/rfdc/examples"

do_compile_prepend () {
    cd ${S}/${RFDC_SUBDIR}
    cp Makefile.Linux Makefile
}
