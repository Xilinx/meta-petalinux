BRANCH = "xlnx-rebase-v1.16.3"
REPO   = "git://github.com/Xilinx/gst-omx.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.3+git${SRCPV}"

SRC_URI = " \
	${REPO};${BRANCHARG};name=gst-omx \
	git://github.com/GStreamer/common.git;protocol=https;destsuffix=git/common;branch=master;name=common \
	"

SRCREV_gst-omx = "7a2d3ccee9012b7cfc9bd27f54cf2b221db66bf3"
SRCREV_common = "88e512ca7197a45c4114f7fa993108f23245bf50"
SRCREV_FORMAT = "gst-omx"

S = "${WORKDIR}/git"


RDEPENDS:${PN}:append:zynqmp = " libomxil-xlnx"
DEPENDS:append:zynqmp = " libomxil-xlnx"

EXTRA_OECONF:append:zynqmp =  " --with-omx-header-path=${STAGING_INCDIR}/vcu-omx-il"
EXTRA_OEMESON += " -Dheader_path=${STAGING_INCDIR}/vcu-omx-il"

GSTREAMER_1_0_OMX_TARGET:zynqmp ?= "zynqultrascaleplus"
GSTREAMER_1_0_OMX_CORE_NAME:zynqmp ?= "${libdir}/libOMX.allegro.core.so.1"

PACKAGE_ARCH:zynqmp = "${SOC_FAMILY_ARCH}"
