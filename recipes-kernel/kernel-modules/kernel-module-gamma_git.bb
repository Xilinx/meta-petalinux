SUMMARY = "Xilinx Gamma LUT IP Linux Kernel Module"
SECTION = "kernel/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=eb723b61539feef013de476e68b5c50a"

XILINX_XGAMMA_VERSION = "1.0.0"
PV = "${XILINX_XGAMMA_VERSION}"
S = "${WORKDIR}/git"

BRANCH ?= "master"
REPO ?= "git://gitenterprise.xilinx.com/ipssw/xilinx-gamma-lut.git;protocol=https"
SRCREV ?= "82b2a15caea39d0f07fce52991dea24c35bfed63"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

inherit module

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"
