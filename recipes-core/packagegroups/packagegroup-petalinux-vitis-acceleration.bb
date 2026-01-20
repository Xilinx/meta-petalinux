DESCRIPTION = "Packages for Vitis compatible platforms"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGES += "${PN}-essential ${PN}-recommends"

RDEPENDS:${PN}-essential:zynqmp = " \
		"

RDEPENDS:${PN}-essential:versal = " \
		"

RDEPENDS:${PN}-essential:versal-net = " \
		"

RDEPENDS:${PN}-essential = " \
		opencl-headers \
		packagegroup-opencv \
		packagegroup-core-x11 \
		"

RRECOMMENDS:${PN}-recommends = " \
		gdb \
		valgrind \
		resize-part \
		htop \
		iperf3 \
		meson \
		dnf \
		"

RDEPENDS:${PN}-essential:append = "${@bb.utils.contains('MACHINE_FEATURES', 'aie', 'ai-engine-driver', '', d)}"
