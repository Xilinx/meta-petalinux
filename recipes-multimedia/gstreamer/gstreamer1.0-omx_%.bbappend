BRANCH ?= "release-2020.2"
REPO   ?= "git://github.com/xilinx/gst-omx.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.0+git${SRCPV}"

SRC_URI = " \
	${REPO};${BRANCHARG};name=gst-omx \
	git://anongit.freedesktop.org/git/gstreamer/common.git;destsuffix=git/common;branch=master;name=common \
	"

SRCREV_gst-omx = "f3061fb074c6ef86df252bfe769ca5bf124fa3bf"
SRCREV_common = "88e512ca7197a45c4114f7fa993108f23245bf50"
SRCREV_FORMAT = "gst-omx"

S = "${WORKDIR}/git"


RDEPENDS_${PN}_append_zynqmp = " libomxil-xlnx"
DEPENDS_append_zynqmp = " libomxil-xlnx"

EXTRA_OECONF_append_zynqmp =  " --with-omx-header-path=${STAGING_INCDIR}/vcu-omx-il"

GSTREAMER_1_0_OMX_TARGET_zynqmp ?= "zynqultrascaleplus"
GSTREAMER_1_0_OMX_CORE_NAME_zynqmp ?= "${libdir}/libOMX.allegro.core.so.1"

PACKAGE_ARCH_zynqmp = "${SOC_FAMILY_ARCH}"
