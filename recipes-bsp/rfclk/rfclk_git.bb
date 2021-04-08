SUMMARY = "rfclk Library"
SECTION = "rfclk"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://license.txt;md5=64e026e5fcf32dffb500cb265cf57fe1"

inherit pkgconfig

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "release-2020.2.2_k26"
SRCREV ??= "6d507ed8c006d8090aec8c10e24ef34706920884"
BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp-dr = "zynqmp-dr"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	${REPO};${BRANCHARG} \
	"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

PROVIDES = "rfclk"

RFCLK_SUBDIR = "XilinxProcessorIPLib/drivers/board_common/src/rfclk/src"

do_compile_prepend() {
    cd ${S}/${RFCLK_SUBDIR}
    cp Makefile.Linux Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}

    cd ${S}/${RFCLK_SUBDIR}
    oe_libinstall -so librfclk ${D}${libdir}
    install -m 0644 xrfclk.h ${D}${includedir}/xrfclk.h
    install -m 0644 xrfclk_LMK_conf.h ${D}${includedir}/xrfclk_LMK_conf.h
    install -m 0644 xrfclk_LMX_conf.h ${D}${includedir}/xrfclk_LMX_conf.h
}

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
