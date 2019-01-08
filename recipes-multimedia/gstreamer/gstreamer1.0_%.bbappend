BRANCH ?= "xlnx-1.14.2"
REPO   ?= "git://gitenterprise.xilinx.com/GStreamer/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}"

PV = "1.14.2+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
    git://anongit.freedesktop.org/git/gstreamer/common.git;destsuffix=git/common;branch=master;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch \
    file://gtk-doc-tweaks.patch \
    file://0001-gst-gstpluginloader.c-when-env-var-is-set-do-not-fal.patch \
    file://add-a-target-to-compile-tests.patch \
    file://run-ptest \
"

SRCREV_gstreamer-xlnx = "afb3d1b3e0d02da8b0eb5bb501356650b38e5644"
SRCREV_common = "f0c2dc9aadfa05bb5274c40da750104ecbb88cba"
SRCREV_FORMAT = "gstreamer-xlnx"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}
