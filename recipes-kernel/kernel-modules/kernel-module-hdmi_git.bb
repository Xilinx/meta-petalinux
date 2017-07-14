SUMMARY = "Xilinx HDMI Linux Kernel module"
SECTION = "kernel/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=eb723b61539feef013de476e68b5c50a"

XILINX_HDMI_VERSION = "1.0.0"
PV = "${XILINX_HDMI_VERSION}"

S = "${WORKDIR}/git"

BRANCH ?= "master"
REPO ?= "git://gitenterprise.xilinx.com/ipssw/hdmi-modules.git;protocol=https"
SRCREV ?= "a0ca96b977dbe18a2a7bb4041346827d4a3c6cb3"
SRC_URI[md5sum] = "9c267ce818c29efdcc5ec405a4b33ae3"
SRC_URI[sha256sum] = "5ca81352d491e5b0bbfc40c7e22451ce1a569e2f6c83c2456af66c9f0f4ca7f1"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

inherit module

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"
