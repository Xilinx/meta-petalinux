SUMMARY = "dfemix Library"
SECTION = "dfemix"
LICENSE = "BSD"

inherit pkgconfig
require conf/embeddedsw.inc

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp-dr = "zynqmp-dr"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	${REPO};${BRANCHARG} \
	"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

DEPENDS = "libmetal"

PROVIDES = "dfemix"

DFEMIX_SUBDIR = "XilinxProcessorIPLib/drivers/dfemix/src"

do_compile_prepend() {
    cd ${S}/${DFEMIX_SUBDIR}
    cp Makefile.Linux Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}

    cd ${S}/${DFEMIX_SUBDIR}
    oe_libinstall -so libdfemix ${D}${libdir}
    install -m 0644 xdfemix_hw.h ${D}${includedir}/xdfemix_hw.h
    install -m 0644 xdfemix.h ${D}${includedir}/xdfemix.h
}

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
