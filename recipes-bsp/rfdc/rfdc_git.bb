SUMMARY = "rfdc Library"
SECTION = "rfdc"
LICENSE = "BSD"

inherit pkgconfig

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2020.3"
SRCREV ??= "d3a68e32d4a57608a3d5bb1106b6ec702621bdb6"
BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

LIC_FILES_CHKSUM="file://license.txt;md5=a3e150f71d508f8ce31ecd0daf5e1abc"

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
