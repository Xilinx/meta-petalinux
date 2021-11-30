# OpenGL comes from libmali on ev/eg, when egl is enabled
DEPENDS:append:mali400 = " libmali-xlnx"

PACKAGE_ARCH:mali400 = "${SOC_VARIANT_ARCH}"
