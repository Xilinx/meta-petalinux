LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/license.txt;md5=04841c5ad8409b474da7180de5391926"

REPO ?= "git://github.com/xilinx/embeddedsw.git;protocol=https"
BRANCH ?= "release-2018.1"
SRCREV = "aaa566bc3fa19255de4d434ebfa57ae3a9d261b2"
COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = " \
		${REPO};${BRANCHARG} \
		file://0001-rfdc-Add-clock-configuration-support-files.patch \
		"

PACKAGE_ARCH = "${SOC_FAMILY}${SOC_VARIANT}"

DEPENDS = "rfdc"
RDEPENDS_${PN} = "rfdc"

PACKAGES = "${PN}-dbg ${PN}"

S = "${WORKDIR}/git/XilinxProcessorIPLib/drivers/rfdc/examples"

do_compile_prepend () {
    cp ${S}/Makefile.Linux ${S}/Makefile
}
