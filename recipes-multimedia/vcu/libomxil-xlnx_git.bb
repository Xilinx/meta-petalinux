DESCRIPTION = "OMX IL Libraries and test applications for VCU in ZynqMP"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=03a7aef7e6f6a76a59fd9b8ba450b493"

BRANCH ?= "master"
REPO   ?= "git://gitenterprise.xilinx.com/xilinx-vcu/vcu-omx-il.git;protocol=https"
SRCREV ?= "183aa311a3308750de27b6c89c3c94e8e0de905d"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"
SRC_URI = "${REPO};${BRANCHARG}"

S  = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

DEPENDS = "libvcu-xlnx"
RDEPENDS_${PN} = "kernel-module-vcu libvcu-xlnx"

EXTERNAL_LIB="${STAGING_INCDIR}/vcu-ctrl-sw"

EXTRA_OEMAKE = " \
    CC='${CC}' CXX='${CXX} ${CXXFLAGS}' \
    EXTERNAL_LIB='${EXTERNAL_LIB}' \
    "

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${libdir}
    install -d ${D}${includedir}/vcu-omx-il

    install -m 0644 ${S}/omx_header/*.h ${D}${includedir}/vcu-omx-il

    install -m 0755 ${S}/bin/omx_decoder.exe ${D}/${bindir}/
    install -m 0755 ${S}/bin/omx_encoder.exe ${D}/${bindir}/

    oe_libinstall -C ${S}/bin/ -so libOMX.allegro.core ${D}/${libdir}/
    oe_libinstall -C ${S}/bin/ -so libOMX.allegro.video_decoder ${D}/${libdir}/
    oe_libinstall -C ${S}/bin/ -so libOMX.allegro.video_encoder ${D}/${libdir}/
}

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.

EXCLUDE_FROM_WORLD = "1"
