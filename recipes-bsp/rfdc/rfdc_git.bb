SUMMARY = "rfdc Library"
SECTION = "rfdc"
LICENSE = "BSD"
LIC_FILES_CHKSUM ="file://${WORKDIR}/git/license.txt;md5=c83c24ed6555ade24e37e6b74ade2629"

inherit pkgconfig

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2019.1"
SRCREV ??= "c53b24258d857065f45cfeca544b5f5a0eaf0feb"
BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	${REPO};${BRANCHARG} \
	"

S = "${WORKDIR}/git/XilinxProcessorIPLib/drivers/rfdc/src/"

PACKAGE_ARCH = "${SOC_FAMILY}${SOC_VARIANT}"

DEPENDS = "libmetal"

PROVIDES = "rfdc"

do_configure() {
    cp ${S}/Makefile.Linux ${S}/Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}
    oe_libinstall -so librfdc ${D}${libdir}
    install -m 0644 ${S}/xrfdc_hw.h ${D}${includedir}/xrfdc_hw.h
    install -m 0644 ${S}/xrfdc.h ${D}${includedir}/xrfdc.h
    install -m 0644 ${S}/xrfdc_mts.h ${D}${includedir}/xrfdc_mts.h
}

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
