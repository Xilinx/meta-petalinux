#
# This file is the aie-plio recipe.
#

SUMMARY = "Simple AIE matrix multiplication application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/Xilinx/plnx-aie-examples.git;protocol=https;branch=rel-v2020.2"
SRCREV = "6cf082319184bc9dc35890bb35a7e74297d07b40"

DEPENDS = "ai-engine-driver xrt"
RDEPENDS_${PN}  = "ai-engine-driver xrt zocl"
INSANE_SKIP_${PN} += " arch"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_versal-ai-core = "versal-ai-core"

S = "${WORKDIR}/git/"

do_compile[noexec] = "1"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}aie-matrix-multiplication ${D}${bindir}
	install -d ${D}/lib/firmware/aie/
	cp -r ${S}Work ${D}/lib/firmware/aie
	cp ${S}aie-matrix-multiplication.xclbin ${D}/lib/firmware/aie
}

FILES_${PN} += " \
	/lib/firmware/aie/Work \
	/lib/firmware/aie/aie-matrix-multiplication.xclbin \
	${bindir}/aie-matrix-multiplication \
"

PACKAGE_ARCH_versal-ai-core = "${SOC_VARIANT_ARCH}"
