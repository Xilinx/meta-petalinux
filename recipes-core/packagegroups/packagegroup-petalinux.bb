DESCRIPTION = "PetaLinux miscellaneous packages"

PACKAGE_ARCH = "${SOC_FAMILY_ARCH}"

inherit packagegroup

# Packages
RDEPENDS:${PN} = "\
	bash \
	bzip2 \
	flex \
	gmp \
	libnet \
	libpng \
	libusb-compat \
	libusb1 \
	popt \
	unzip \
	zlib \
	tcf-agent \
	"

ZYNQ_EXTRAS = " \
	dnf \
	libattr \
	libinput \
	gdb \
	libftdi \
	cmake \
	"

RDEPENDS:${PN}:append:zynq = " \
	${ZYNQ_EXTRAS} \
	"

RDEPENDS:${PN}:append:zynqmp = " \
	${ZYNQ_EXTRAS} \
	"
RDEPENDS:${PN}:append:versal = " \
	${ZYNQ_EXTRAS} \
	"
