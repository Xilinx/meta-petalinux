PACKAGECONFIG ?= "opengl-none gstreamer1 pulseaudio luajit ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'wayland', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = "\
    file://0001-elua-fix-build-for-luajit2.1.0-beta3.patch \
"
