FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0001-Fix-gles3-header-when-gles2-is-enabled.patch \
"

PACKAGECONFIG_append = " gles2"
