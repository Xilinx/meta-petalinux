FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://0001-Make-RGB565-as-default-EGLconfig.patch \
                   file://0001-src-options.cpp-Add-options-to-configure-bpp-and-dep.patch \
                   file://0001-native-state-fbdev-Add-support-for-glmark2-es2-fbdev.patch \
                   file://0001-src-gl-state-egl-Use-native_display-to-load-EGL-func.patch \
		"

PACKAGECONFIG = "${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'x11-gl x11-gles2', '', d)} \
		${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'drm-gles2 wayland-gles2', '', d)} \
		${@bb.utils.contains('DISTRO_FEATURES', 'fbdev', 'fbdev-glesv2', '', d)}"

PACKAGECONFIG[fbdev-glesv2] = ",,virtual/libgles2 virtual/egl"

EXTRA_OECONF_append = "${@bb.utils.contains('DISTRO_FEATURES', 'fbdev', ' --with-flavors=fbdev-glesv2', '', d)}"

PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"
