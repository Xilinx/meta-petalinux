SUMMARY = "rfdc Library"
SECTION = "rfdc"
LICENSE = "BSD"

inherit pkgconfig

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "master-rel-2020.2"
SRCREV ??= "abf960cf328005f18d0c25b0960e2ba08e55c4f7"
BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

LIC_FILES_CHKSUM="file://license.txt;md5=64f55aaa4b1bbdab348c0703190d558a"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	${REPO};${BRANCHARG} \
	"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

DEPENDS = "libmetal"

PROVIDES = "rfdc"

RFDC_SUBDIR = "XilinxProcessorIPLib/drivers/rfdc/src"

do_compile_prepend() {
    cd ${S}/${RFDC_SUBDIR}
    cp Makefile.Linux Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}

    cd ${S}/${RFDC_SUBDIR}
    oe_libinstall -so librfdc ${D}${libdir}
    install -m 0644 xrfdc_hw.h ${D}${includedir}/xrfdc_hw.h
    install -m 0644 xrfdc.h ${D}${includedir}/xrfdc.h
    install -m 0644 xrfdc_mts.h ${D}${includedir}/xrfdc_mts.h
}

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
