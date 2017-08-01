BRANCH ?= "master-rel-1.8.3"
REPO ?= "git://github.com/Xilinx/gst-plugins-base.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

PV = "1.8.3+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    git://anongit.freedesktop.org/gstreamer/common;destsuffix=git/common;name=common \
    file://get-caps-from-src-pad-when-query-caps.patch \
    file://0003-ssaparse-enhance-SSA-text-lines-parsing.patch \
    file://0004-subparse-set-need_segment-after-sink-pad-received-GS.patch \
    file://encodebin-Need-more-buffers-in-output-queue-for-bett.patch \
    file://make-gio_unix_2_0-dependency-configurable.patch \
    "

SRCREV_base = "8539c9e86827db95027cb25e487e3f6c287c00c7"
SRCREV_common = "6f2d2093e84cc0eb99b634fa281822ebb9507285"
SRCREV_FORMAT = "base"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
