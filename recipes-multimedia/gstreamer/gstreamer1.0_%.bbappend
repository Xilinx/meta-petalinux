BRANCH ?= "xlnx-rebase-v1.16.3"
REPO   ?= "git://github.com/Xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.3+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
    git://github.com/GStreamer/common.git;protocol=https;destsuffix=git/common;branch=master;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch;patchdir=common \
    file://0001-gstreamer-use-a-patch-instead-of-sed-to-fix-gtk-doc.patch;patchdir=common \
    file://0001-gst-gstpluginloader.c-when-env-var-is-set-do-not-fal.patch \
    file://0001-gst-inspect.c-Set-DEFAULT_PAGER-more-instead-of-less.patch \
    file://0002-meson-build-gir-even-when-cross-compiling-if-introsp.patch \
    file://0003-meson-Add-valgrind-feature.patch \
    file://0004-meson-Add-option-for-installed-tests.patch \
    file://0005-bufferpool-only-resize-in-reset-when-maxsize-is-larger.patch \
"

SRCREV_gstreamer-xlnx = "cdc91b6ae73ca9d8404cfc54f417bca4a8fb351a" 
SRCREV_common = "88e512ca7197a45c4114f7fa993108f23245bf50"
SRCREV_FORMAT = "gstreamer-xlnx"

PACKAGECONFIG_append = " tracer-hooks"

S = "${WORKDIR}/git"

do_configure_prepend() {
        ${S}/autogen.sh --noconfigure
}

delete_pkg_m4_file() {
        # This m4 file is out of date and is missing PKG_CONFIG_SYSROOT_PATH tweaks which we need for introspection
        rm "${S}/common/m4/pkg.m4" || true
        rm -f "${S}/common/m4/gtk-doc.m4"
}

do_configure[prefuncs] += "delete_pkg_m4_file"
