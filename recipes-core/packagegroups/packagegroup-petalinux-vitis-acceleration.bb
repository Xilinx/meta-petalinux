DESCRIPTION = "Packages for Vitis compatible platforms"

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

PACKAGE_ARCH:versal-ai-core = "${MACHINE_ARCH}"
RDEPENDS:${PN}-essential:append:versal-ai-core = "ai-engine-driver"
