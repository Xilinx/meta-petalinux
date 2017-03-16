DESCRIPTION = "Video Codec Unit (VCU) for ZynqMP binaries"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8b15b341f0c40cfe32c36969be4bb1bc"

XLNX_VCU_VERSION = "1.0.0"
PV = "1.0.0+git${SRCPV}"

S  = "${WORKDIR}/git"

BRANCH ?= "master"
REPO   ?= "git://github.com/Xilinx/vcu-binaries.git;protocol=https"
SRCREV ?= "1aeb4908b810369aa299c0fae251f7e4e74dedaa"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

RDEPENDS_${PN} = "kernel-module-vcu"

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${libdir}

    cp -a --no-preserve=ownership ${S}/${XLNX_VCU_VERSION}/usr/bin/* ${D}/${bindir}/
    cp -a --no-preserve=ownership ${S}/${XLNX_VCU_VERSION}/usr/lib/*.so* ${D}/${libdir}/
}

# Inhibit warnings about files being stripped
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_SYSROOT_STRIP = "1"
FILES_${PN} = "${bindir}/* ${libdir}/*"

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.
EXCLUDE_FROM_WORLD = "1"

INSANE_SKIP_${PN} = "ldflags"
