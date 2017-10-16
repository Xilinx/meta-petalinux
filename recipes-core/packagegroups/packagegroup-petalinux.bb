DESCRIPTION = "PetaLinux Packages, all packages avaliable in PetaLinux"
LICENSE = "NONE"

inherit packagegroup

# Packages
RDEPENDS_${PN} += "\
	bash \
	bridge-utils \
	bzip2 \
	dropbear \
	e2fsprogs \
	ethtool \
	flex \
	glib-2.0 \
	gmp \
	i2c-tools \
	iproute2 \
	iptables \
	libnet \
	libpcre \
	libpng \
	libusb-compat \
	libusb1 \
	mtd-utils \
	net-tools \
	netcat \
	pciutils \
	popt \
	rpcbind \
	tcpdump \
	unzip \
	usbutils \
	util-linux \
	zlib \
	strace \
	"
ZYNQ_EXTRAS = " \
	dnf \
	libattr \
	libdrm \
	libdrm-tests \
	libinput \
	python-multiprocessing \
	python-numpy \
	python-scons \
	python-shell \
	python-threading \
	python3-pyserial \
	python-pyserial \
	python3-pip\
	python-pip \
	smartmontools \
	tcf-agent \
	v4l-utils \
	gst-plugins-good \
	yavta \
	ffmpeg \
	gdb \
	libftdi \
	lmsensors-sensors \
	lmsensors-libsensors \
	cmake \
	"

RDEPENDS_${PN}_append_microblaze = " \
	tcf-agent \
	"

RDEPENDS_${PN}_append_zynq = " \
	${ZYNQ_EXTRAS} \
	"

RDEPENDS_${PN}_append_zynqmp = " \
	${ZYNQ_EXTRAS} \
	"
