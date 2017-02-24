PACKAGECONFIG += " \
  examples accessibility tools libinput \
  ${@bb.utils.contains('DISTRO_FEATURES', 'alsa', 'alsa', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'fbdev', 'linuxfb gles2 eglfs', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'gles2 eglfs', '', d)} \
  "
