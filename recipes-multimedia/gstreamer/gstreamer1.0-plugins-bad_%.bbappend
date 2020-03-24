BRANCH ?= "release-2019.2"
REPO ?= "git://github.com/xilinx/gst-plugins-bad.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.0+git${SRCPV}"

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
"

SRCREV_base = "33016ba0374828b3188f9c9b236b185a5496cfe7"
SRCREV_common = "88e512ca7197a45c4114f7fa993108f23245bf50"
SRCREV_FORMAT = "base"

PACKAGECONFIG_append = " faac kms faad opusparse"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
