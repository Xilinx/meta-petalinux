DESCRIPTION = "PetaLinux miscellaneous utilities packages"

inherit packagegroup

UTILS_PACKAGES = " \
	util-linux \
	cpufrequtils \
	bridge-utils \
	mtd-utils \
	usbutils \
	pciutils \
	canutils \
	i2c-tools \
	smartmontools \
	e2fsprogs \
	"

RDEPENDS_${PN} = "${UTILS_PACKAGES}"
