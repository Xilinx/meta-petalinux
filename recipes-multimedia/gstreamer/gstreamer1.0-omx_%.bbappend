BRANCH ?= "master-rel-1.2.0"
REPO   ?= "git://github.com/Xilinx/gst-omx.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

SRC_URI = " \
	${REPO};${BRANCHARG};name=gst-omx \
	git://anongit.freedesktop.org/gstreamer/common;destsuffix=git/common;branch=master;name=common \
	"

SRCREV_gst-omx = "92a1d20bf1da9a57b83e8517d15dc9b96556584f"
SRCREV_common = "1f5d3c3163cc3399251827235355087c2affa790"
SRCREV_FORMAT = "gst-omx"

S = "${WORKDIR}/git"

do_configure_prepend() {
	cd ${S}
	./autogen.sh --noconfigure
	cd ${B}
}

RDEPENDS_${PN}_append_zynqmp = " ${@bb.utils.contains('MACHINE_HWCODECS', 'libomxil-xlnx', 'libomxil-xlnx', '', d)}"
DEPENDS_append_zynqmp = " ${@bb.utils.contains('MACHINE_HWCODECS', 'libomxil-xlnx', 'libomxil-xlnx', '', d)}"

EXTRA_OECONF_append_zynqmp =  " ${@bb.utils.contains('MACHINE_HWCODECS', 'libomxil-xlnx', '--with-omx-header-path=${STAGING_INCDIR}/vcu-omx-il', '', d)}"

GSTREAMER_1_0_OMX_TARGET_zynqmp ?= "${@bb.utils.contains('MACHINE_HWCODECS', 'libomxil-xlnx', 'zynqultrascaleplus', 'bellagio', d)}"
GSTREAMER_1_0_OMX_CORE_NAME_zynqmp ?= "${@bb.utils.contains('MACHINE_HWCODECS', 'libomxil-xlnx', '${libdir}/libOMX.allegro.core.so.1', '${libdir}/libomxil-bellagio.so.0', d)}"
