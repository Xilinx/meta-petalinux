SUMMARY = "dfeccf Library"
SECTION = "dfeccf"
LICENSE = "BSD"

inherit pkgconfig xlnx-embeddedsw

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp-dr = "zynqmp-dr"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

DEPENDS = "libmetal"

PROVIDES = "dfeccf"

DFECCF_SUBDIR = "XilinxProcessorIPLib/drivers/dfeccf/src"

do_compile_prepend() {
    cd ${S}/${DFECCF_SUBDIR}
    cp Makefile.Linux Makefile
}

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}

    cd ${S}/${DFECCF_SUBDIR}
    oe_libinstall -so libdfeccf ${D}${libdir}
    install -m 0644 xdfeccf_hw.h ${D}${includedir}/xdfeccf_hw.h
    install -m 0644 xdfeccf.h ${D}${includedir}/xdfeccf.h
}

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
