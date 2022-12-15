require gstreamer-1.20.3.inc

S = "${WORKDIR}/git/subprojects/gst-omx"

RDEPENDS:${PN}:append:zynqmp = " libomxil-xlnx"
DEPENDS:append:zynqmp = " libomxil-xlnx"

EXTRA_OECONF:append:zynqmp =  " --with-omx-header-path=${STAGING_INCDIR}/vcu-omx-il"
EXTRA_OEMESON += " -Dheader_path=${STAGING_INCDIR}/vcu-omx-il"

GSTREAMER_1_0_OMX_TARGET:zynqmp ?= "zynqultrascaleplus"
GSTREAMER_1_0_OMX_CORE_NAME:zynqmp ?= "${libdir}/libOMX.allegro.core.so.1"

PACKAGE_ARCH:zynqmp = "${SOC_FAMILY_ARCH}"
