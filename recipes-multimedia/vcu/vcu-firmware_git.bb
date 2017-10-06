DESCRIPTION = "Video Codec Unit Firmware for ZynqMP binaries"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=63b45903a9a50120df488435f03cf498"

XILINX_VCU_VERSION = "1.0.0"
PV = "${XILINX_VCU_VERSION}+git${SRCPV}"

S  = "${WORKDIR}/git"

BRANCH ?= "master"
REPO ?= "git://github.com/Xilinx/vcu-firmware.git;protocol=https"
SRCREV ?= "93249bb4f87280acc322a336d8658d15f69a7ac4"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI   = "${REPO};${BRANCHARG}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

do_install() {
    install -d ${D}/lib/firmware
    cp -a --no-preserve=ownership ${S}/${XILINX_VCU_VERSION}/lib/firmware/* ${D}/lib/firmware/
}

# Inhibit warnings about files being stripped
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"
FILES_${PN} = "/lib/firmware/*"

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.
EXCLUDE_FROM_WORLD = "1"

INSANE_SKIP_${PN} = "ldflags"
