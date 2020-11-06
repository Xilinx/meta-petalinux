# OpenGL comes from libmali on ev/eg, when egl is enabled
DEPENDS_append_zynqmpev = " libmali-xlnx"
DEPENDS_append_zynqmpeg = " libmali-xlnx"

PACKAGE_ARCH_zynqmpev = "${SOC_VARIANT_ARCH}"
PACKAGE_ARCH_zynqmpeg = "${SOC_VARIANT_ARCH}"
