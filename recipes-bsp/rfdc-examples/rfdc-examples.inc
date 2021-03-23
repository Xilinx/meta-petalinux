LICENSE = "BSD"
LIC_FILES_CHKSUM="file://license.txt;md5=a3e150f71d508f8ce31ecd0daf5e1abc"

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2020.3"
SRCREV ??= "68ced7ee3b4197830c1266b3973654c7952f0af7"

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
