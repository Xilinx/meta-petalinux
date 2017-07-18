SUMMARY = "Xilinx Video Mixer Linux Kernel module"
SECTION = "kernel/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=eb723b61539feef013de476e68b5c50a"

XILINX_XVMIXER_VERSION = "1.0.0"
PV = "${XILINX_XVMIXER_VERSION}"

S = "${WORKDIR}/git"

BRANCH ?= "master"
REPO ?= "git://gitenterprise.xilinx.com/ipssw/xvmixer-module.git;protocol=https"
SRCREV = "73f18048b401ec3a6a8a4b11294b693e4a3878ac"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

inherit module

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"
