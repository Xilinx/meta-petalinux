#
# This file is the aie-plio recipe.
#

SUMMARY = "Simple AIE matrix multiplication application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
	   file://reset-aie-array.sh \
	   file://aie-matrix-multiplication \
	   file://Work \
	  "
DEPENDS = "ai-engine-driver"
RDEPENDS_${PN}  = "ai-engine-driver"
INSANE_SKIP_${PN} += " arch"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 reset-aie-array.sh ${D}${bindir}
	install -m 0755 aie-matrix-multiplication ${D}${bindir}
	install -d ${D}/lib/firmware/aie/
	cp -r ${S}/Work ${D}/lib/firmware/aie
}

FILES_${PN} += " \
	/lib/firmware/aie/Work \
	${bindir}/reset-aie-array.sh \
	${bindir}/aie-matrix-multiplication \
"

