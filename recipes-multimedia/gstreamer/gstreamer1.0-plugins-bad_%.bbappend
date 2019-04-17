BRANCH ?= "xlnx-1.14.2"
REPO ?= "git://gitenterprise.xilinx.com/GStreamer/gst-plugins-bad.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

PV = "1.14.2+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    git://anongit.freedesktop.org/gstreamer/common;destsuffix=git/common;name=common \
    file://configure-allow-to-disable-libssh2.patch \
    file://fix-maybe-uninitialized-warnings-when-compiling-with-Os.patch \
    file://avoid-including-sys-poll.h-directly.patch \
    file://ensure-valid-sentinels-for-gst_structure_get-etc.patch \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch \
    file://0001-Makefile.am-don-t-hardcode-libtool-name-when-running.patch \
"

SRCREV_base = "513ef5efdf85f9af4a016e8ae69f28cf16c9ec58"
SRCREV_common = "f0c2dc9aadfa05bb5274c40da750104ecbb88cba"
SRCREV_FORMAT = "base"

PACKAGECONFIG[xlnxvideoscale] = "--enable-xlnxvideoscale,--disable-xlnxvideoscale"
PACKAGECONFIG_append = " faac kms faad opusparse xlnxvideoscale"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
