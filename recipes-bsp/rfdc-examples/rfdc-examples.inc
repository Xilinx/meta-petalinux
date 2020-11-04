LICENSE = "BSD"
LIC_FILES_CHKSUM="file://license.txt;md5=64f55aaa4b1bbdab348c0703190d558a"

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "master-rel-2020.2"
SRCREV ??= "abf960cf328005f18d0c25b0960e2ba08e55c4f7"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

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
