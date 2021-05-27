BRANCH = "xlnx-rebase-v1.16.3"
REPO   = "git://github.com/Xilinx/gst-omx.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.3+git${SRCPV}"

SRC_URI = " \
	${REPO};${BRANCHARG};name=gst-omx \
	git://github.com/GStreamer/common.git;protocol=https;destsuffix=git/common;branch=master;name=common \
	"

SRCREV_gst-omx = "0ff294b7e75a34d72c8b918aa0fc61dad977db1e"
SRCREV_common = "88e512ca7197a45c4114f7fa993108f23245bf50"
SRCREV_FORMAT = "gst-omx"

S = "${WORKDIR}/git"


RDEPENDS_${PN}_append_zynqmp = " libomxil-xlnx"
DEPENDS_append_zynqmp = " libomxil-xlnx"

EXTRA_OECONF_append_zynqmp =  " --with-omx-header-path=${STAGING_INCDIR}/vcu-omx-il"
EXTRA_OEMESON += " -Dheader_path=${STAGING_INCDIR}/vcu-omx-il"

GSTREAMER_1_0_OMX_TARGET_zynqmp ?= "zynqultrascaleplus"
GSTREAMER_1_0_OMX_CORE_NAME_zynqmp ?= "${libdir}/libOMX.allegro.core.so.1"

PACKAGE_ARCH_zynqmp = "${SOC_FAMILY_ARCH}"
