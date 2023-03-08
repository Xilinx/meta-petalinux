SUMMARY = "dfeofdm Library"
SECTION = "dfeofdm"
LICENSE = "BSD-3-Clause"

inherit pkgconfig xlnx-embeddedsw

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp-dr = "zynqmp-dr"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

DEPENDS = "libmetal"

PROVIDES = "dfeofdm"

DFEOFDM_SUBDIR = "XilinxProcessorIPLib/drivers/dfeofdm/src"

do_compile:prepend() {
    cd ${S}/${DFEOFDM_SUBDIR}
    cp Makefile.Linux Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}

    cd ${S}/${DFEOFDM_SUBDIR}
    oe_libinstall -so libdfeofdm ${D}${libdir}
    install -m 0644 xdfeofdm_hw.h ${D}${includedir}/xdfeofdm_hw.h
    install -m 0644 xdfeofdm.h ${D}${includedir}/xdfeofdm.h
}

FILES:${PN} = "${libdir}/*.so.*"
FILES:${PN}-dev = "${libdir}/*.so  ${includedir}/*"
