# This change appears to only affect ZynqMP configurations
PACKAGE_ARCH:zynqmp = "${MACHINE_ARCH}"
FILESEXTRAPATHS:prepend:zynqmp := "${THISDIR}/${PN}:"
SRC_URI:append:zynqmp = " \
		file://0001-default.pai.in-disable-tsched-system-timer-based-mod.patch \
		"
