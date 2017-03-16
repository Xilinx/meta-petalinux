SUMMARY = "Video Codec Unit (VCU) Linux Kernel module"
SECTION = "kernel/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=eb723b61539feef013de476e68b5c50a"

XLNX_VCU_VERSION = "1.0.0"
PV = "1.0.0+git${SRCPV}"

S = "${WORKDIR}/git"

BRANCH ?= "master"
REPO   ?= "git://github.com/Xilinx/vcu-modules.git;protocol=https"
SRCREV ?= "6e3533bba7e23382cdb9bee696db055e9cac26bd"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

inherit module

RDEPENDS_${PN} = "vcu-firmware"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

