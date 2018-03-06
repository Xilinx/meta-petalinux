PACKAGECONFIG_append = " \
  examples accessibility tools libinput fontconfig \
  ${@bb.utils.contains('DISTRO_FEATURES', 'fbdev', 'linuxfb gles2 eglfs', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'gles2 eglfs', '', d)} \
  "
PACKAGECONFIG_remove = "tests"
