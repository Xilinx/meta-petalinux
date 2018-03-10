BRANCH ?= "xilinx-master"
REPO   ?= "git://github.com/xilinx/gst-omx.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

SRC_URI = " \
	${REPO};${BRANCHARG};name=gst-omx \
	git://anongit.freedesktop.org/git/gstreamer/common.git;destsuffix=git/common;branch=master;name=common \
	"

SRCREV_gst-omx = "c57d14b08f2dc7ced3fad638c04c53588d75ad79"
SRCREV_common = "48a5d85ebf4a0bad1c997c83100f710fe2154fbf"
SRCREV_FORMAT = "gst-omx"

S = "${WORKDIR}/git"


RDEPENDS_${PN}_append_zynqmp = " libomxil-xlnx"
DEPENDS_append_zynqmp = " libomxil-xlnx"

EXTRA_OECONF_append_zynqmp =  " --with-omx-header-path=${STAGING_INCDIR}/vcu-omx-il"

GSTREAMER_1_0_OMX_TARGET_zynqmp ?= "zynqultrascaleplus"
GSTREAMER_1_0_OMX_CORE_NAME_zynqmp ?= "${libdir}/libOMX.allegro.core.so.1"

PACKAGE_ARCH_zynqmp = "${SOC_FAMILY}"
