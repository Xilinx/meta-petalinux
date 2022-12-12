FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# TODO: Two patches are disabled as they do not apply to the current version of glmark2
#       This will need review by someone familiar with that code
SRC_URI:append = " file://0001-Make-RGB565-as-default-EGLconfig.patch \
                   file://0001-src-options.cpp-Add-options-to-configure-bpp-and-dep.patch;apply=0 \
                   file://0002-native-state-fbdev-Add-support-for-glmark2-es2-fbdev.patch \
                   file://0001-src-gl-state-egl-Use-native_display-to-load-EGL-func.patch;apply=0 \
                   file://0003-EGL-eglplatform.h-Remove-the-eglplatform.h-header.patch  \
		"

PACKAGECONFIG = " \
  ${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'x11-gl x11-gles2', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'drm-gles2 wayland-gles2', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'fbdev', 'fbdev-glesv2', '', d)} \
"

PACKAGECONFIG[fbdev-glesv2] = ",,virtual/libgles2 virtual/egl"

EXTRA_OECONF:append = "${@bb.utils.contains('DISTRO_FEATURES', 'fbdev', ' --with-flavors=fbdev-glesv2', '', d)}"

# Links to libmali-xlnx, so it becomes MACHINE_ARCH specific
DEFAULT_PACKAGE_ARCH := "${PACKAGE_ARCH}"
MALI_PACKAGE_ARCH = "${@'${MACHINE_ARCH}' if d.getVar('PREFERRED_PROVIDER_virtual/libgles1') == 'libmali-xlnx' else '${DEFAULT_PACKAGE_ARCH}'}"
PACKAGE_ARCH = "${@bb.utils.contains_any('DEPENDS', 'virtual/libgles1 virtual/libgles2 virtual/egl virtual/libgbm', '${MALI_PACKAGE_ARCH}', '${DEFAULT_PACKAGE_ARCH}', d)}"
