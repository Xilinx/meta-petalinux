DESCRIPTION = "Video Codec Unit Firmware for ZynqMP binaries"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8b15b341f0c40cfe32c36969be4bb1bc"

XLNX_VCU_VERSION = "1.0.0"
PV = "1.0.0+git${SRCPV}"

S  = "${WORKDIR}/git"

BRANCH ?= "master"
REPO   ?= "git://gitenterprise.xilinx.com/xilinx-vcu/vcu-firmware.git;protocol=https"
SRCREV ?= "370d90eb3206b69b8c456b70d8c91297fe2339db"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI   = "${REPO};${BRANCHARG}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"


do_install() {
    install -d ${D}/lib/firmware
    cp -a --no-preserve=ownership ${S}/${XLNX_VCU_VERSION}/lib/firmware/* ${D}/lib/firmware/
}

# Inhibit warnings about files being stripped
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"
FILES_${PN} = "/lib/firmware/*"

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.
EXCLUDE_FROM_WORLD = "1"

INSANE_SKIP_${PN} = "ldflags"
