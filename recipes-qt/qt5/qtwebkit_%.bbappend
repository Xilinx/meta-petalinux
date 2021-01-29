# OpenGL comes from libmali on ev/eg, when egl is enabled
DEPENDS_append_zynqmp-ev = " libmali-xlnx"
DEPENDS_append_zynqmp-eg = " libmali-xlnx"

PACKAGE_ARCH_zynqmp-ev = "${SOC_VARIANT_ARCH}"
PACKAGE_ARCH_zynqmp-eg = "${SOC_VARIANT_ARCH}"
