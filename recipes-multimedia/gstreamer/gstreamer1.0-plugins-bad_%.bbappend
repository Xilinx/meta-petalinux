PACKAGECONFIG_append = "faad gles2"

FILESEXTRAPATHS_prepend := "${THISDIR}/gstreamer1.0-plugins-bad:"

DEPENDS += "libdrm"

SRC_URI_append = " \
    file://0001-gst-plugins-bad-Copy-kmssink-from-1.9.2.patch \
    file://0002-gst-kmssink-Compile-kms.patch \
    file://0003-gst-kmssink-Add-support-for-xilinx-drm.patch \
    file://0004-kmssink-override-stride-if-defined-in-driver.patch \
    file://0005-kmssink-Fix-selection-of-source-region.patch \
    file://0006-kmssink-Scale-up-to-the-screen-dimension.patch \
    file://0007-kmssink-Calculate-the-offset-for-framebuffer-planes-.patch \
    file://0008-kmssink-Allocate-dumb-buffers-with-bpp-as-per-video-.patch \
    file://0009-kmssink-Link-with-video-and-base-libs.patch \
"

