BRANCH = "xlnx-rebase-v1.18.5"
REPO   = "git://gitenterprise.xilinx.com/GStreamer/gst-omx.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.18.5+git${SRCPV}"

SRC_URI = " \
	${REPO};${BRANCHARG};name=gst-omx \
"

SRCREV_gst-omx = "2f70767baefda712a10a9331aaf7aea6cb4f6c65"
SRCREV_FORMAT = "gst-omx"

S = "${WORKDIR}/git"


RDEPENDS_${PN}:append:zynqmp = " libomxil-xlnx"
DEPENDS:append:zynqmp = " libomxil-xlnx"

EXTRA_OECONF:append:zynqmp =  " --with-omx-header-path=${STAGING_INCDIR}/vcu-omx-il"
EXTRA_OEMESON += " -Dheader_path=${STAGING_INCDIR}/vcu-omx-il"

GSTREAMER_1_0_OMX_TARGET:zynqmp ?= "zynqultrascaleplus"
GSTREAMER_1_0_OMX_CORE_NAME:zynqmp ?= "${libdir}/libOMX.allegro.core.so.1"

PACKAGE_ARCH:zynqmp = "${SOC_FAMILY_ARCH}"
