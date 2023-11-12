SUMMARY = "rfclk Library"
SECTION = "rfclk"

inherit pkgconfig xlnx-embeddedsw

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp-dr = "zynqmp-dr"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

PROVIDES = "rfclk"

RFCLK_SUBDIR = "XilinxProcessorIPLib/drivers/board_common/src/rfclk/src"

do_compile:prepend() {
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

FILES:${PN} = "${libdir}/*.so.*"
FILES:${PN}-dev = "${libdir}/*.so  ${includedir}/*"
