BRANCH ?= "xlnx-rebase-v1.16.3"
REPO ?= "git://github.com/Xilinx/gst-plugins-base.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.3+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = " file://gtk-doc-tweaks.patch"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    git://github.com/GStreamer/common.git;protocol=https;destsuffix=git/common;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch;patchdir=common \
    file://0001-gstreamer-use-a-patch-instead-of-sed-to-fix-gtk-doc.patch;patchdir=common \
    file://get-caps-from-src-pad-when-query-caps.patch \
    file://0001-meson-build-gir-even-when-cross-compiling-if-introsp.patch \
    file://0002-meson-Add-variables-for-gir-files.patch \
    file://0003-ssaparse-enhance-SSA-text-lines-parsing.patch \
    file://0005-viv-fb-Make-sure-config.h-is-included.patch \
    file://0009-glimagesink-Downrank-to-marginal.patch \
"

SRCREV_base = "d1fd9a95fd5a38f3a941ac1821ce36d3b8e624f8" 
SRCREV_common = "88e512ca7197a45c4114f7fa993108f23245bf50"
SRCREV_FORMAT = "base"

PACKAGECONFIG_append = " opus"

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
