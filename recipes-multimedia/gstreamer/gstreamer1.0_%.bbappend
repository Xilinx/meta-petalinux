BRANCH ?= "release-2019.2"
REPO   ?= "git://github.com/xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

PV = "1.14.4+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
    git://anongit.freedesktop.org/git/gstreamer/common.git;destsuffix=git/common;branch=master;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch;patchdir=common \
    file://0001-gstreamer-use-a-patch-instead-of-sed-to-fix-gtk-doc.patch;patchdir=common \
    file://0001-gst-gstpluginloader.c-when-env-var-is-set-do-not-fal.patch \
    file://add-a-target-to-compile-tests.patch \
    file://run-ptest \
"

SRCREV_gstreamer-xlnx = "c3c502011e3585749c664e6d2125c49419bb9889"
SRCREV_common = "f0c2dc9aadfa05bb5274c40da750104ecbb88cba"
SRCREV_FORMAT = "gstreamer-xlnx"

PACKAGECONFIG_append = " gst-tracer-hooks"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
