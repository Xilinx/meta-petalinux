SUMMARY = "Xilinx HDMI Linux Kernel module"
DESCRIPTION = "Out-of-tree HDMI kernel modules provider for MPSoC EG/EV devices"
SECTION = "kernel/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=eb723b61539feef013de476e68b5c50a"

XLNX_HDMI_VERSION = "1.0.0"
PV = "${XLNX_HDMI_VERSION}"

S = "${WORKDIR}/git"

BRANCH ?= "master"
REPO   ?= "git://github.com/xilinx/hdmi-modules.git;protocol=https"
SRCREV ?= "20a28aa3e6c007d34d811ae8308d74e835a1d4e4"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

inherit module

EXTRA_OEMAKE += "O=${STAGING_KERNEL_BUILDDIR}"
COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

PACKAGE_ARCH = "${SOC_FAMILY}"
