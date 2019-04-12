DESCRIPTION = "PetaLinux miscellaneous packages"

inherit packagegroup

# Packages
RDEPENDS_${PN} = "\
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

RDEPENDS_${PN}_append_zynq = " \
	${ZYNQ_EXTRAS} \
	"

RDEPENDS_${PN}_append_zynqmp = " \
	${ZYNQ_EXTRAS} \
	"
RDEPENDS_${PN}_append_versal = " \
	${ZYNQ_EXTRAS} \
	"
