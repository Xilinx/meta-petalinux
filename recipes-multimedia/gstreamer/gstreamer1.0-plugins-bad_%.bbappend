BRANCH ?= "release-2020.1"
REPO ?= "git://github.com/xilinx/gst-plugins-bad.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.3+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = " file://gtk-doc-tweaks.patch"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    git://github.com/GStreamer/common.git;protocol=https;destsuffix=git/common;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch;patchdir=common \
    file://0001-gstreamer-use-a-patch-instead-of-sed-to-fix-gtk-doc.patch;patchdir=common \
    file://fix-maybe-uninitialized-warnings-when-compiling-with-Os.patch \
    file://avoid-including-sys-poll.h-directly.patch \
    file://ensure-valid-sentinels-for-gst_structure_get-etc.patch \
    file://0001-meson-build-gir-even-when-cross-compiling-if-introsp.patch \
    file://opencv-resolve-missing-opencv-data-dir-in-yocto-buil.patch \
"

SRCREV_base = "19b2018f2c31c0011c78fa7300544165739dc91a"
SRCREV_common = "88e512ca7197a45c4114f7fa993108f23245bf50"
SRCREV_FORMAT = "base"

PACKAGECONFIG[mediasrcbin] = "-Dmediasrcbin=enabled,-Dmediasrcbin=disabled,media-ctl"
PACKAGECONFIG_append = " faac kms faad opusparse mediasrcbin"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
