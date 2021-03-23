SUMMARY = "dfeprach Library"
SECTION = "dfeprach"
LICENSE = "BSD"
LIC_FILES_CHKSUM="file://license.txt;md5=3a6e22aebf6516f0f74a82e1183f74f8"

inherit pkgconfig

REPO = "git://gitenterprise.xilinx.com/embeddedsw/embeddedsw.git;protocol=https"
BRANCH = "master"
SRCREV = "db82844b998dd8d41e5d7ecb45422de72044cc3d"

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

PROVIDES = "dfeprach"

DFEMIX_SUBDIR = "XilinxProcessorIPLib/drivers/dfeprach/src"

do_compile_prepend() {
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

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-dev = "${libdir}/*.so  ${includedir}/*"
