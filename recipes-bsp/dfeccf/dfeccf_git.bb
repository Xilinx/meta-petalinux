SUMMARY = "dfeccf Library"
SECTION = "dfeccf"
LICENSE = "BSD"
LIC_FILES_CHKSUM="file://license.txt;md5=3a6e22aebf6516f0f74a82e1183f74f8"

inherit pkgconfig

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"
BRANCH ??= "master-rel-2020.2"
SRCREV ??= "08b9f4304d1634ed632f4276d603d834940fd55a"
BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	${REPO};${BRANCHARG} \
	"

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
