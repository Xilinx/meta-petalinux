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
	dropbear-openssh-sftp-server \
	openssh-sftp-server \
	pciutils \
	popt \
	portmap \
	tcpdump \
	unzip \
	usbutils \
	util-linux \
	zlib \
	strace \
	"
ZYNQ_EXTRAS = " \
	libattr \
	libdrm \
	libdrm-tests \
	libinput \
	python-multiprocessing \
	python-numpy \
	python-scons \
	python-shell \
	python-threading \
	python-smartpm \
	python-pyserial \
	smartmontools \
	tcf-agent \
	v4l-utils \
	gst-plugins-good \
	yavta \
	ffmpeg \
	gdb \
	libftdi \
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
