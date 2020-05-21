#
# This file is the aie-plio recipe.
#

SUMMARY = "Simple AIE matrix multiplication application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/Xilinx/plnx-aie-examples.git;protocol=https;branch=rel-v2020.1"
SRCREV = "e4ce2174e3225b95352536f5f9ad2b5f13ffd538"

DEPENDS = "ai-engine-driver"
RDEPENDS_${PN}  = "ai-engine-driver"
INSANE_SKIP_${PN} += " arch"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_versal = "versal"

S = "${WORKDIR}/git/"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 aie-matrix-multiplication ${D}${bindir}
	install -d ${D}/lib/firmware/aie/
	cp -r ${S}/Work ${D}/lib/firmware/aie
}

FILES_${PN} += " \
	/lib/firmware/aie/Work \
	${bindir}/aie-matrix-multiplication \
"

