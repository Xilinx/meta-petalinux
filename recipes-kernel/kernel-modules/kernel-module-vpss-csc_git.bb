SUMMARY = "Xilinx VPSS Color Space Converter Linux Kernel Module"
SECTION = "kernel/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=eb723b61539feef013de476e68b5c50a"

XILINX_XCSC_VERSION = "1.0.0"
PV = "${XILINX_XCSC_VERSION}"
S = "${WORKDIR}/git"

BRANCH ?= "master"
REPO ?= "git://gitenterprise.xilinx.com/ipssw/xilinx-vpss-csc.git;protocol=https"
SRCREV ?= "4a8245cfbd18e61cdc056f6aef8d77cf503f3469"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

inherit module

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"
