PACKAGECONFIG_append = " faad gles2"

BRANCH ?= "master-rel-1.8.3"
REPO ?= "git://github.com/Xilinx/gst-plugins-bad.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

PV = "1.8.3+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    git://anongit.freedesktop.org/gstreamer/common;destsuffix=git/common;name=common \
    file://configure-allow-to-disable-libssh2.patch \
    file://fix-maybe-uninitialized-warnings-when-compiling-with-Os.patch \
    file://avoid-including-sys-poll.h-directly.patch \
    file://ensure-valid-sentinels-for-gst_structure_get-etc.patch \
    file://0001-gstreamer-gl.pc.in-don-t-append-GL_CFLAGS-to-CFLAGS.patch \
    "

SRCREV_base = "8e8b435affd4e4e240516345ee11a6b8b01630e2"
SRCREV_common = "6f2d2093e84cc0eb99b634fa281822ebb9507285"
SRCREV_FORMAT = "base"

DEPENDS += "libdrm"
S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
