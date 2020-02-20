DESCRIPTION = "PetaLinux miscellaneous utilities packages"

inherit packagegroup

UTILS_PACKAGES = " \
	util-linux \
	cpufrequtils \
	bridge-utils \
	mtd-utils \
	usbutils \
	pciutils \
	can-utils \
	i2c-tools \
	smartmontools \
	e2fsprogs \
	"

RDEPENDS_${PN} = "${UTILS_PACKAGES}"
