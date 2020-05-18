LICENSE = "BSD"
LIC_FILES_CHKSUM="file://license.txt;md5=8b565227e1264d677db8f841c2948cba"

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2020.1"
SRCREV ??= "5a7828fc8dc13cb693a8e78cc69172cf637b213d"

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
