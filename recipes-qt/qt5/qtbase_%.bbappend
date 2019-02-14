FILESEXTRAPATHS_prepend := "${THISDIR}/qtbase:"

SRC_URI_append = " \
    file://0002-egl_kms-Modify-the-default-color-format-to-RGB565.patch \
"

PACKAGECONFIG_append = " \
  examples accessibility tools libinput fontconfig \
  ${@bb.utils.contains('DISTRO_FEATURES', 'fbdev', 'linuxfb gles2 eglfs', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'gles2 eglfs', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'gles2 eglfs kms gbm', '', d)} \
  "

PACKAGECONFIG_remove = "tests"
