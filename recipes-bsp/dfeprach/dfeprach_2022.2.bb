SUMMARY = "dfeprach Library"
SECTION = "dfeprach"
LICENSE = "BSD"

inherit pkgconfig xlnx-embeddedsw

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp-dr = "zynqmp-dr"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

DEPENDS = "libmetal"

PROVIDES = "dfeprach"

DFEMIX_SUBDIR = "XilinxProcessorIPLib/drivers/dfeprach/src"

do_compile:prepend() {
    cd ${S}/${DFEMIX_SUBDIR}
    cp Makefile.Linux Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}

    cd ${S}/${DFEMIX_SUBDIR}
    oe_libinstall -so libdfeprach ${D}${libdir}
    install -m 0644 xdfeprach_hw.h ${D}${includedir}/xdfeprach_hw.h
    install -m 0644 xdfeprach.h ${D}${includedir}/xdfeprach.h
}

FILES:${PN} = "${libdir}/*.so.*"
FILES:${PN}-dev = "${libdir}/*.so  ${includedir}/*"
