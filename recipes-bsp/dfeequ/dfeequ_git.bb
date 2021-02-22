SUMMARY = "dfeequ Library"
SECTION = "dfeequ"
LICENSE = "BSD"
LIC_FILES_CHKSUM="file://license.txt;md5=3a6e22aebf6516f0f74a82e1183f74f8"

inherit pkgconfig

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "master-rel-2020.2"
SRCREV ??= "08b9f4304d1634ed632f4276d603d834940fd55a"
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

PROVIDES = "dfeequ"

DFEEQU_SUBDIR = "XilinxProcessorIPLib/drivers/dfeequ/src"

do_compile_prepend() {
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

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
