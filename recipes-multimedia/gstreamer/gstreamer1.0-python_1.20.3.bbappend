require gstreamer-xilinx-1.20.3.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-gstpythonplugin.c-Specifying-Major-and-Minor-version.patch \
"

EXTRA_OEMESON += "-Dlibpython-dir=${libdir}"
UNKNOWN_CONFIGURE_OPT_IGNORE:append = " introspection"

S = "${WORKDIR}/git/subprojects/gst-python"

