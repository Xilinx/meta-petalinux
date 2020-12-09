BRANCH ?= "release-2020.1"
REPO ?= "git://github.com/xilinx/gst-plugins-base.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.16.3+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = " file://gtk-doc-tweaks.patch"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=base \
    git://anongit.freedesktop.org/gstreamer/common;destsuffix=git/common;name=common \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch;patchdir=common \
    file://0001-gstreamer-use-a-patch-instead-of-sed-to-fix-gtk-doc.patch;patchdir=common \
    file://get-caps-from-src-pad-when-query-caps.patch \
    file://0001-meson-build-gir-even-when-cross-compiling-if-introsp.patch \
    file://0002-meson-Add-variables-for-gir-files.patch \
    file://0003-ssaparse-enhance-SSA-text-lines-parsing.patch \
    file://0005-viv-fb-Make-sure-config.h-is-included.patch \
    file://0009-glimagesink-Downrank-to-marginal.patch \
"

SRCREV_base = "ffc05bce0bc02cb2cafd50914f01640dab47f274"
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
