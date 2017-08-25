SUMMARY = "Video Codec Unit (VCU) Linux Kernel module"
SECTION = "kernel/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=eb723b61539feef013de476e68b5c50a"

XILINX_VCU_VERSION = "1.0.0"
PV = "${XILINX_VCU_VERSION}"

S = "${WORKDIR}/git"

BRANCH ?= "master"
REPO ?= "git://github.com/Xilinx/vcu-modules.git;protocol=https"
SRCREV ?= "b78a787f538a5adcde874e08fee8b8c9af2a6186"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

inherit module

RDEPENDS_${PN} = "vcu-firmware"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"
