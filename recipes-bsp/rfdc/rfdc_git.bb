SUMMARY = "rfdc Library"
SECTION = "rfdc"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/license.txt;md5=530190e8d7ebcdfeddbe396f3f20417f"

inherit pkgconfig

REPO ?= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ?= "release-2017.3"
SRCREV = "3c9f0cfde9307c2dc1a298f9f22d492601232821"
BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	${REPO};${BRANCHARG} \
	"

S = "${WORKDIR}/git/XilinxProcessorIPLib/drivers/rfdc/src/"

PACKAGE_ARCH = "${MACHINE_ARCH}"

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
    install -m 0644 ${S}/xparameters.h ${D}${includedir}/xparameters.h
    install -m 0644 ${S}/xparameters_ps.h ${D}${includedir}/xparameters_ps.h
}

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
