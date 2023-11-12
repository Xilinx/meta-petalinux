SUMMARY = "dfeequ Library"
SECTION = "dfeequ"
LICENSE = "BSD"

inherit pkgconfig xlnx-embeddedsw

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp-dr = "zynqmp-dr"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

DEPENDS = "libmetal"

PROVIDES = "dfeequ"

DFEEQU_SUBDIR = "XilinxProcessorIPLib/drivers/dfeequ/src"

do_compile:prepend() {
    cd ${S}/${DFEEQU_SUBDIR}
    cp Makefile.Linux Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}

    cd ${S}/${DFEEQU_SUBDIR}
    oe_libinstall -so libdfeequ ${D}${libdir}
    install -m 0644 xdfeequ_hw.h ${D}${includedir}/xdfeequ_hw.h
    install -m 0644 xdfeequ.h ${D}${includedir}/xdfeequ.h
}

FILES:${PN} = "${libdir}/*.so.*"
FILES:${PN}-dev = "${libdir}/*.so  ${includedir}/*"
