DESCRIPTION = "Packages for Vitis compatible platforms"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGES += "${PN}-essential ${PN}-recommends"

RDEPENDS:${PN}-essential:zynqmp = " \
		xrt \
		kernel-module-zocl \
		"

RDEPENDS:${PN}-essential:versal = " \
		xrt \
		kernel-module-zocl \
		"

RDEPENDS:${PN}-essential:versal-net = " \
		xrt \
		kernel-module-zocl \
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
