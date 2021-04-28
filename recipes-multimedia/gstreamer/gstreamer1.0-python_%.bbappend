FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-gstpythonplugin.c-Specifying-Major-and-Minor-version.patch"

EXTRA_OEMESON += "-Dlibpython-dir=${libdir}"
