DESCRIPTION = "Packages for Vitis compatible platforms"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGES += "${PN}-essential ${PN}-recommends"

RDEPENDS:${PN}-essential = " \
		xrt \
		zocl \
		opencl-headers \
		packagegroup-petalinux-opencv \
		packagegroup-petalinux-x11 \
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

RDEPENDS:${PN}-essential:append:versal-ai-core = "ai-engine-driver"
