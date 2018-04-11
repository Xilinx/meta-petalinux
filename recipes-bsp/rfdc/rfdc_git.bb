SUMMARY = "rfdc Library"
SECTION = "rfdc"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/license.txt;md5=2a8d7a7f870f65ce77e8ccd8150cce10"

inherit pkgconfig

REPO ?= "git://github.com/xilinx/embeddedsw.git;protocol=https"
BRANCH ?= "release-2018.2"
SRCREV = "6e82c0183bdfb9c6838966b9b87ef8385ba35504"
BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	${REPO};${BRANCHARG} \
	"

S = "${WORKDIR}/git/XilinxProcessorIPLib/drivers/rfdc/src/"

PACKAGE_ARCH = "${SOC_FAMILY}${SOC_VARIANT}"

DEPENDS = "libmetal virtual/fsbl"

PROVIDES = "rfdc"

STAGING_RFDC_DIR = "${TMPDIR}/work-shared/${MACHINE}/rfdc-source"

do_configure() {
    cp ${STAGING_RFDC_DIR}/xrfdc_g.c ${S}
    cp ${STAGING_RFDC_DIR}/xparameters.h ${S}
    cp ${STAGING_RFDC_DIR}/xparameters_ps.h ${S}
    cp ${S}/Makefile.Linux ${S}/Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}
    oe_libinstall -so librfdc ${D}${libdir}
    install -m 0644 ${S}/xrfdc_hw.h ${D}${includedir}/xrfdc_hw.h
    install -m 0644 ${S}/xrfdc.h ${D}${includedir}/xrfdc.h
    install -m 0644 ${S}/xrfdc_mts.h ${D}${includedir}/xrfdc_mts.h
    install -m 0644 ${S}/xparameters.h ${D}${includedir}/xparameters.h
    install -m 0644 ${S}/xparameters_ps.h ${D}${includedir}/xparameters_ps.h
}

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
