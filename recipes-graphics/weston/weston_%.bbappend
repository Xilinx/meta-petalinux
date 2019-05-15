FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://0001-gl-renderer.c-Use-gr-egl_config-to-create-pbuffer-su.patch \
    file://0001-FIX-weston-clients-typo-in-simple-dmabuf-egl.c.patch \
"
