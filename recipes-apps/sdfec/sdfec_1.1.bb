#
# This file is the sdfec recipe.
#

SUMMARY = "sdfec applications"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "libmetal"

SRC_URI = "git://github.com/Xilinx/linux-examples.git;protocol=https;nobranch=1"
SRCREV = "06501085caa27d3141d10c687e07bb49acfd7b81"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpdr = "zynqmpdr"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

S = "${WORKDIR}/git/sd-fec-1.1"

TARGETS_APPS ?= "sdfec-demo sdfec-interrupts sdfec-multi-ldpc-codes"

do_compile() {
	for app_name in ${TARGETS_APPS}; do
		oe_runmake -C ${S}/$app_name/files
	done
}

do_install() {
	install -d ${D}${bindir}
	for app_name in ${TARGETS_APPS}; do
		install -m 0755 ${S}/$app_name/files/$app_name ${D}${bindir}
	done
}
