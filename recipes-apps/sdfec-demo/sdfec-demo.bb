#
# This file is the sdfec-demo recipe.
#

SUMMARY = "sdfec-demo application"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"


DEPENDS += "libmetal libsdfecusrintf"

SRC_URI = "\
            file://demo_test_drivers.c \
            file://Makefile \
            file://demo_test_drivers.h \
            file://main.c \
            file://xdata_source_top.c \
            file://xdata_source_top.h \
            file://xdata_source_top_hw.h \
            file://xdata_source_top_sinit.c \
            file://xmonitor.c \
            file://xmonitor.h \
            file://xmonitor_hw.h \
            file://xmonitor_sinit.c \
            file://xsd_fec_dec_docsis_long_params.h \
            file://xsd_fec_dec_docsis_medium_params.h \
            file://xsd_fec_dec_docsis_short_params.h \
            file://xsd_fec_enc_docsis_long_params.h \
            file://xsd_fec_enc_docsis_medium_params.h \
            file://xsd_fec_enc_docsis_short_params.h \
            file://xstats_top.c \
            file://xstats_top.h \
            file://xstats_top_hw.h \
            file://xstats_top_sinit.c \
          "

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

S = "${WORKDIR}"

do_install() {
         install -d ${D}${bindir}
         install -m 0755 sdfec-demo ${D}${bindir}
}
