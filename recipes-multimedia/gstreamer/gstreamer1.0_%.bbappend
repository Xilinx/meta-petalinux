BRANCH ?= "release-2020.1"
REPO   ?= "git://github.com/xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.0+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
    git://anongit.freedesktop.org/git/gstreamer/common.git;destsuffix=git/common;branch=master;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch;patchdir=common \
    file://0001-gstreamer-use-a-patch-instead-of-sed-to-fix-gtk-doc.patch;patchdir=common \
    file://0001-gst-gstpluginloader.c-when-env-var-is-set-do-not-fal.patch \
    file://add-a-target-to-compile-tests.patch \
    file://run-ptest \
    file://0001-gst-inspect.c-Set-DEFAULT_PAGER-more-instead-of-less.patch \
"

SRCREV_gstreamer-xlnx = "10db9688beab0b11ea2e8c5b05d78c57a589ad03"
SRCREV_common = "88e512ca7197a45c4114f7fa993108f23245bf50"
SRCREV_FORMAT = "gstreamer-xlnx"

PACKAGECONFIG_append = " gst-tracer-hooks"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
