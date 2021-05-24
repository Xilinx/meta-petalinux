# OpenGL comes from libmali on ev/eg, when egl is enabled
DEPENDS_append_mali400 = " libmali-xlnx"

PACKAGE_ARCH_mali400 = "${SOC_VARIANT_ARCH}"
