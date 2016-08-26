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

QT_EXTRAS = " \
        ruby \
	cpufrequtils \
	qtbase-dev \
	qtbase-fonts \
	qtbase-mkspecs \
	qtbase-plugins \
	qtbase-staticdev \
	qttranslations-qt \
	qttranslations-qtbase \
	qttranslations-qtconfig \
	qttranslations-qthelp \
	qtconnectivity-dev \
	qtconnectivity-mkspecs \
	qttranslations-qtconnectivity \
	qtdeclarative-dev \
	qtdeclarative-mkspecs \
	qtdeclarative-plugins \
	qtdeclarative-staticdev \
	qttranslations-qmlviewer \
	qttranslations-qtdeclarative \
	qtenginio-dev \
	qtenginio-mkspecs \
	qtimageformats-dev \
	qtimageformats-plugins \
	qtlocation-dev \
	qtlocation-mkspecs \
	qtlocation-plugins \
	qttranslations-qtmultimedia \
	qtscript-dev \
	qtscript-mkspecs \
	qttranslations-qtscript \
	qtsensors-dev \
	qtsensors-mkspecs \
	qtsensors-plugins \
	qtserialport-dev \
	qtserialport-mkspecs \
	qtsvg-dev \
	qtsvg-mkspecs \
	qtsvg-plugins \
	qttools-dev \
	qttools-mkspecs \
	qttools-staticdev \
	qttools-tools \
	qtwebsockets-dev \
	qtwebsockets-mkspecs \
	qttranslations-qtwebsockets \
	qtwebchannel-dev \
	qtwebchannel-mkspecs \
	qtxmlpatterns-dev \
	qtxmlpatterns-mkspecs \
	qttranslations-qtxmlpatterns \
	qtbase-examples \
	qtquick1-dev \
	qtquick1-mkspecs \
	qtquick1-plugins \
	qttranslations-qtquick1 \
	qtwebkit-dev \
	qtwebkit-mkspecs \
	qttools-plugins \
	libopencv-core-dev \
	libopencv-highgui-dev \
	libopencv-imgproc-dev \
	libopencv-objdetect-dev \
	libopencv-ml-dev \
	libopencv-calib3d \
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
	"

RDEPENDS_${PN}_append_microblaze += " \
	tcf-agent \
	"

RDEPENDS_${PN}_append_zynq += " \
	${ZYNQ_EXTRAS} \
	${QT_EXTRAS} \
	"

RDEPENDS_${PN}_append_zynqmp += " \
	${ZYNQ_EXTRAS} \
	${QT_EXTRAS} \
	"
