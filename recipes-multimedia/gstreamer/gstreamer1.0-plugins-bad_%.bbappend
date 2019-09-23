BRANCH ?= "rel-v2019.1"
REPO ?= "git://github.com/xilinx/gst-plugins-bad.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

PV = "1.14.4+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = " file://gtk-doc-tweaks.patch"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    git://anongit.freedesktop.org/gstreamer/common;destsuffix=git/common;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch;patchdir=common \
    file://0001-gstreamer-use-a-patch-instead-of-sed-to-fix-gtk-doc.patch;patchdir=common \
    file://configure-allow-to-disable-libssh2.patch \
    file://fix-maybe-uninitialized-warnings-when-compiling-with-Os.patch \
    file://avoid-including-sys-poll.h-directly.patch \
    file://ensure-valid-sentinels-for-gst_structure_get-etc.patch \
    file://0001-Makefile.am-don-t-hardcode-libtool-name-when-running.patch \
"

SRCREV_base = "ec1ff1219c99db2a9cc5262027f9b4d20f5f4e81"
SRCREV_common = "f0c2dc9aadfa05bb5274c40da750104ecbb88cba"
SRCREV_FORMAT = "base"

PACKAGECONFIG[xlnxvideoscale] = "--enable-xlnxvideoscale,--disable-xlnxvideoscale"
PACKAGECONFIG_append = " faac kms faad opusparse xlnxvideoscale"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
