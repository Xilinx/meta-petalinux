LICENSE = "BSD"
LIC_FILES_CHKSUM="file://license.txt;md5=39ab6ab638f4d1836ba994ec6852de94"

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2019.2"
SRCREV ??= "e8db5fb118229fdc621e0ec7848641a23bf60998"

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
