require gstreamer-xilinx-1.20.5.inc

S = "${WORKDIR}/git/subprojects/gst-omx"

RDEPENDS:${PN} .= "${@bb.utils.contains('MACHINE_FEATURES', 'vcu', ' libomxil-xlnx', '', d)}"
DEPENDS .= "${@bb.utils.contains('MACHINE_FEATURES', 'vcu', ' libomxil-xlnx', '', d)}"

EXTRA_OECONF .= "${@bb.utils.contains('MACHINE_FEATURES', 'vcu', ' --with-omx-header-path=${STAGING_INCDIR}/vcu-omx-il', '', d)}"
EXTRA_OEMESON .= "${@bb.utils.contains('MACHINE_FEATURES', 'vcu', ' -Dheader_path=${STAGING_INCDIR}/vcu-omx-il', '', d)}"

DEFAULT_GSTREAMER_1_0_OMX_TARGET := "${GSTREAMER_1_0_OMX_TARGET}"
GSTREAMER_1_0_OMX_TARGET = "${@bb.utils.contains('MACHINE_FEATURES', 'vcu', 'zynqultrascaleplus', '${DEFAULT_GSTREAMER_1_0_OMX_TARGET}', d)}"

DEFAULT_GSTREAMER_1_0_OMX_CORE_NAME := "${GSTREAMER_1_0_OMX_CORE_NAME}"
GSTREAMER_1_0_OMX_CORE_NAME = "${@bb.utils.contains('MACHINE_FEATURES', 'vcu', '${libdir}/libOMX.allegro.core.so.1', '${DEFAULT_GSTREAMER_1_0_OMX_CORE_NAME}', d)}"

DEFAULT_PACKAGE_ARCH := "${PACKAGE_ARCH}"
PACKAGE_ARCH = "${@bb.utils.contains('MACHINE_FEATURES', 'vcu', '${MACHINE_ARCH}', '${DEFAULT_PACKAGE_ARCH}', d)}"
