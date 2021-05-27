BRANCH ?= "xlnx-rebase-v1.16.3"
REPO ?= "git://github.com/Xilinx/gst-plugins-good.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.3+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = " file://gtk-doc-tweaks.patch"
SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    git://github.com/GStreamer/common.git;protocol=https;destsuffix=git/common;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch;patchdir=common \
    file://0001-gstreamer-use-a-patch-instead-of-sed-to-fix-gtk-doc.patch;patchdir=common \
    file://0001-qmlgl-ensure-Qt-defines-GLsync-to-fix-compile-on-som.patch \
    file://0001-qt-include-ext-qt-gstqtgl.h-instead-of-gst-gl-gstglf.patch \
"

SRCREV_base = "f89f5c9e39ced253694adbab18e91fdbab1ac3b6"
SRCREV_common = "f0c2dc9aadfa05bb5274c40da750104ecbb88cba"
SRCREV_FORMAT = "base"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
