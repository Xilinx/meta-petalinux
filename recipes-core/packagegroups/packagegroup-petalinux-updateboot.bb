DESCRIPTION = "Required packages for updateboot"

inherit packagegroup

PACKAGE_ARCH = "${MACHINE_ARCH}"

UPDATEBOOT_PACKAGES = " \
    updateboot \
    u-boot-xlnx \
    device-tree \
    bootgen \
	"

UPDATEBOOT_PACKAGES_append_zynq = " \
    fsbl \
    bitstream-extraction \
	"

UPDATEBOOT_PACKAGES_append_zynqmp = " \
    fsbl \
    bitstream-extraction \
    pmu-firmware \
    arm-trusted-firmware \
    device-tree \
	"

RDEPENDS_${PN} = "${UPDATEBOOT_PACKAGES}"
