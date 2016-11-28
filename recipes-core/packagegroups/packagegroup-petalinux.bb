DESCRIPTION = "PetaLinux Packages, all packages avaliable in PetaLinux"
LICENSE = "NONE"

inherit packagegroup

# Packages
RDEPENDS_${PN} = "\
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
 	opencv \
	python-multiprocessing \
	python-numpy \
	python-scons \
	python-shell \
	python-threading \
	python-smartpm \
	smartmontools \
	tcf-agent \
	v4l-utils \
	yavta \
	libmetal \
	open-amp \
	ffmpeg \
	gstreamer \
	gdb \
	qwt \
	"

RDEPENDS_${PN}_append_microblaze += " \
	tcf-agent \
	"

RDEPENDS_${PN}_append_zynq += " \
	${ZYNQ_EXTRAS} \
	"

RDEPENDS_${PN}_append_zynqmp += " \
	libmetal-amp-demo \
	openamp-echo-test \
	openamp-mat-mul \
	openamp-proxy-app \
	${ZYNQ_EXTRAS} \
	"
