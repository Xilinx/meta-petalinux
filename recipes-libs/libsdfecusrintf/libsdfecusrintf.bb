#
# This file is the libsdfecusrintf recipe.
#

SUMMARY = "Software library providing user interface control needed for sdfec demo"
SECTION = "libs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
            file://sdfec_usr_intf.c \
            file://sdfec_usr_intf.h \
            file://xilinx_sdfec.h \
            file://Makefile \
          "
COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

S = "${WORKDIR}"

PACKAGE_ARCH    = "${MACHINE_ARCH}"

PROVIDES        = "libsdfecusrintf"

do_install() {
         install -d ${D}${libdir}
         install -d ${D}${includedir}
         oe_libinstall -so libsdfecusrintf ${D}${libdir}
         install -d -m 0655 ${D}${includedir}
         install -m 0644 ${S}/*.h ${D}${includedir}
}

FILES_${PN} = "${libdir}/*.so.* ${includedir}"
FILES_${PN}-dev = "${libdir}/*.so"
